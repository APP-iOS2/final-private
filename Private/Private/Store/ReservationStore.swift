//
//  ReservationStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift   //GeoPoint 사용을 위한 프레임워크

final class ReservationStore: ObservableObject {
    @Published var reservationList: [Reservation] = []
    
    private let db = Firestore.firestore()
    
    static let user = Auth.auth().currentUser
    
    init() {
        
    }
    
    static let tempReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    
    /// Double 타입의 날짜를 String으로 변형
    /// 만약, 예약 날짜가 오늘이면 오늘(요일) 형태로 바꿔줌
    func getReservationDate(reservationDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")  // 요일을 한국어로 얻기 위해 로케일 설정
        
        if Calendar.current.isDateInToday(reservationDate) {
            // 예약 날짜가 오늘일 경우
            dateFormatter.dateFormat = "오늘(E)"
        } else {
            dateFormatter.dateFormat = "MM월 dd일"
        }
        
        let dateString = dateFormatter.string(from: reservationDate)
        return dateString
    }
    
    
    /// ReservationList에 추가하기
    /// - Parameter tempReservation: 임시 예약 데이터
    func appendReservationList(tempReservation: Reservation) {
        let reservationData = tempReservation
        self.reservationList.append(reservationData)
    }
    
    
    /// 예약 배열을 날짜 및 시간 순으로 정렬
    func sortReservationList() {
        self.reservationList.sort { first, second in
            if first.date != second.date {
                   first.date > second.date
               } else {
                   first.time > second.time
               }
        }
        print(#fileID, #function, #line, "- 내 예약 수: \(reservationList.count) ")
    }
    
    
    // MARK: - 예약 조회
    /// 서버에서 예약내역 가져오기
    func fetchReservation() {
        // 아직 종료되지 않은 예약과 끝난 예약은 비교해야함 (isDone 같은 걸 사용하거나, 날짜를 비교하여 지난 날이면 자동 처리)
        
        // 이거는 나중에 싱글톤패턴으로 가져오면 편할 듯 (Feed에서 쓸 정보임)
        guard let user = Auth.auth().currentUser else {
            print("로그인 정보가 없습니다.")
            return
        }
        
        guard let email = user.email  else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        self.reservationList.removeAll()
        
        // Field에 reservedUserId의 값이 현재 로그인한 유저의 email이면 전부 반환됨
        let query = self.db.collection("Reservation").whereField("reservedUserId", isEqualTo: email)
        
        query.getDocuments { querySnapshop, error in
            if let error {
                print("쿼리 에러: \(error)")
            } else {
                for document in querySnapshop!.documents {
                    let documentID = document.documentID  // document ID 가져오기
                    let data = document.data()  // 문서 데이터 가져오기
                    
                    guard let dateTime = self.timeStampTodateTime(data: data) else {
                        print("Timestamp 날짜/시간 변환 실패")
                        return
                    }
                    
                    // Reservation 구조체에 맞게 데이터 매핑
                    let reservation = Reservation(id: documentID,
                                                  shopId: data["shopId"] as? String ?? "",
                                                  reservedUserId: email,
                                                  date: dateTime.0,
                                                  time: dateTime.1,
                                                  numberOfPeople: data["numberOfPeople"] as? Int ?? 0,
                                                  totalPrice: data["totalPrice"] as? Int ?? 0,
                                                  requirement: data["requirement"] as? String ?? "")
                    
                    self.appendReservationList(tempReservation: reservation)
                }
                self.sortReservationList()
            }
        }
    }
    
    
    // MARK: - 예약 등록
    /// Firestore Database에 예약 등록
    /// - Parameter reservationData: 예약 데이터
    func addReservationToFirestore(reservationData: Reservation) {
        let documentRef = self.db.collection("Reservation").document(reservationData.id)
        
        guard let user = Self.user else {
            print("로그인 정보가 없습니다.")
            return
        }
        
        guard let email = user.email  else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        guard let dateTimestamp: Timestamp = dateTimeStringToTimeStamp(reservationDate: reservationData.date, reservationHour: reservationData.time) else {
            print("예약 등록 실패 - 날짜 변환 실패")
            return
        }
        
        let reservationData: [String: Any] = [
            "shopId": reservationData.shopId,
            "reservedUserId": email,
            "date": dateTimestamp,
            "numberOfPeople": reservationData.numberOfPeople,
            "totalPrice": reservationData.totalPrice,
            "requirement": reservationData.requirement ?? "요구사항 없음"  // 나중에 수정
        ]
        
        // Firestore에 예약 정보 추가
        documentRef.setData(reservationData) { error in
            if let error = error {
                print("Error adding reservation: \(error.localizedDescription)")
            } else {
                print("Reservation added to Firestore")
            }
        }
    }
    
    
    // MARK: - 예약 수정
    func updateReservation(reservaton: Reservation) {
        
    }
    
    
    // MARK: - 예약 취소(삭제)
    func removeReservation(reservation: Reservation) {
        
    }
    
    
    // MARK: - Firestore에 등록하기 위한 타입 변환
    /// Date 타입의 날짜와 Int 타입의 시간을 Timestamp 타입으로 리턴
    /// - Parameters:
    ///   - reservationDate: 예약 날짜(Date)
    ///   - reservationHour: 예약 시간(Int)
    /// - Returns: Timestamp?
    func dateTimeStringToTimeStamp(reservationDate: Date, reservationHour: Int) -> Timestamp? {
        // Date 객체에서 시간 구성 요소 가져오기
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reservationDate)
        
        // 시간 구성 요소의 시간 부분을 Int 타입의 시간으로 설정
        dateComponents.hour = reservationHour
        dateComponents.minute = 0
        dateComponents.second = 0
        
        // Timestamp 생성
        if let combinedDate = calendar.date(from: dateComponents) {
            let timestamp = Timestamp(date: combinedDate)
            return timestamp
        } else {
            print("Timestamp 변환 실패")
            return nil   // optional로 하고 nil 리턴?
        }
    }
    
    
    /// Firebase의 Timestamp 타입을 Date 타입의 날짜와 Int 타입의 시간으로 리턴
    /// - Parameter data: Firebase에서 query의 결과로 가져온 데이터
    /// - Returns: (Date, Int)?
    func timeStampTodateTime(data: [String : Any]) -> (Date, Int)? {
        // Firestore Timestamp를 Date로 변환
        if let timestamp = data["date"] as? Timestamp {
            let date = timestamp.dateValue()
            
            // Date와 time 프로퍼티로 나누기 (예: 시간은 Int 타입으로 저장)
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//            let year = components.year ?? 0
//            let month = components.month ?? 0
//            let day = components.day ?? 0
            let hour = components.hour ?? 0
//            let minute = components.minute ?? 0
            
            return (date, hour)
        }
        return nil
    }

    
    /// 예약가능한 시간을 배열로 리턴
    /// - Parameters:
    ///   - open: 오픈시간
    ///   - close: 마감시간
    ///   - date: 예약 날짜
    /// - Returns: 예약 가능 시간대
    func getAvailableTimeSlots(open: Int, close: Int, date: Date) -> [Int] {  // 브레이크 타임 받아야 함
        let reservationDate: Date = date
        let openTime: Int = open
        let closeTime: Int = close
        
        if Calendar.current.isDateInToday(reservationDate) {
            let nowInt = Int("HH".stringFromDate())
            
            if let nowInt {
                // 현재 시간이 마감시간보다 같거나 늦으면 빈 배열 반환
                guard nowInt <= closeTime else {
                    return []
                }
                
                // 현재 시간이 오픈시간 전이거나 같을 때
                guard nowInt >= openTime else {
                    let times = Array(openTime...closeTime - 1)
                    return times
                }
                
                // 오픈시간 ~ 마감시간 전일 때
                let times = Array(nowInt + 1...closeTime - 1)
                return times
            }
        } else {
            // 선택한 날짜가 미래 일 때
            let times = Array(openTime...closeTime - 1)
            return times
        }
        return [0]
    }
     
}
