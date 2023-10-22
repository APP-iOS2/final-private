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
    @Published var myReservation: Reservation = tempReservation
    
    private let db = Firestore.firestore()
    static let user = Auth.auth().currentUser
    
    init() {
        self.fetchReservation()
    }
    
    static let tempReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    
    /// Double 타입의 날짜를 String으로 변형
    /// 만약, 예약 날짜가 오늘이면 오늘(요일) 형태로 바꿔줌
    func getReservationDate(reservationDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")  // 요일을 한국어로 얻기 위해 로케일 설정
        let currentYear = Calendar.current.component(.year, from: Date())
        let reservationYear = Calendar.current.component(.year, from: reservationDate)
        
        if Calendar.current.isDateInToday(reservationDate) {  // 예약 날짜가 오늘일 때
            // 예약 날짜가 오늘일 경우
            dateFormatter.dateFormat = "오늘(E)"
        } else if currentYear == reservationYear {  // 올 해일 때
            dateFormatter.dateFormat = "MM월 dd일(E)"
        } else {
            dateFormatter.dateFormat = "yy년 MM월 dd일(E)"
        }
        
        let dateString = dateFormatter.string(from: reservationDate)
        return dateString
    }
    
    private func appendReservationList(tempReservation: Reservation) {
        let reservationData = tempReservation
        self.reservationList.append(reservationData)
    }
    
    private func sortReservationList() {
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
        guard let user = Auth.auth().currentUser else {
            print("로그인 정보가 없습니다.")
            return
        }
        
        guard let email = user.email  else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        self.reservationList.removeAll()
        
        let query = self.db.collection("User").document(email).collection("MyReservation")
        
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
        guard let user = Self.user else {
            print("로그인 정보가 없습니다.")
            return
        }
        
        guard let email = user.email  else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        let docRef = self.db.collection("Reservation").document(reservationData.id)
        let userDocRef = self.db.collection("User").document(email).collection("MyReservation").document(reservationData.id)
        
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
        
        // Firestore Reservation에 추가
        docRef.setData(reservationData) { error in
            if let error = error {
                print("Error adding reservation: \(error.localizedDescription)")
            } else {
                print("Reservation added to Firestore")
            }
        }
        
        // Firestore User의 서브 컬렉션에 추가
        userDocRef.setData(reservationData) { error in
            if let error = error {
                print("Error adding reservation: \(error.localizedDescription)")
            } else {
                print("Reservation added to Firestore")
            }
        }
        self.fetchReservation()
    }
    
    
    // MARK: - 예약 수정
    func updateReservation(reservation: Reservation) {
        guard let email = Self.user!.email  else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        let docRef = db.collection("Reservation").document(reservation.id)
        let userDocRef = self.db.collection("User").document(email).collection("MyReservation").document(reservation.id)

        guard let user = Self.user else {
            print("로그인 정보가 없습니다.")
            return
        }
        
        guard let email = user.email  else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        guard let dateTimestamp: Timestamp = dateTimeStringToTimeStamp(reservationDate: reservation.date, reservationHour: reservation.time) else {
            print("예약 등록 실패 - 날짜 변환 실패")
            return
        }
        
        // 업데이트할 데이터를 만듭니다.
        let reservationData: [String: Any] = [
            "shopId": reservation.shopId,
            "reservedUserId": email,  // userEmail
            "date": dateTimestamp,    // 
            "numberOfPeople": reservation.numberOfPeople,
            "totalPrice": reservation.totalPrice,
            "requirement": reservation.requirement ?? "요구사항 없음"
        ]
        
        // 문서 업데이트
        docRef.updateData(reservationData) { error in
            if let error = error {
                print("문서 업데이트 오류: \(error.localizedDescription)")
            } else {
                print("문서 업데이트 성공")
            }
        }
        
        userDocRef.updateData(reservationData) { error in
            if let error = error {
                print("문서 업데이트 오류: \(error.localizedDescription)")
            } else {
                print("문서 업데이트 성공")
                self.fetchReservation()
            }
        }
        self.fetchReservation()
    }
    
    
    // MARK: - 예약 취소
    func removeReservation(reservation: Reservation) {
        guard let email = Self.user!.email  else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        let docRef = db.collection("Reservation").document(reservation.id)
        let userDocRef = self.db.collection("User").document(email).collection("MyReservation").document(reservation.id)

        // 문서 삭제
        docRef.delete { error in
            if let error = error {
                print("문서 삭제 오류: \(error.localizedDescription)")
            } else {
                print("문서 삭제 성공")
            }
        }
        
        userDocRef.delete { error in
            if let error = error {
                print("문서 삭제 오류: \(error.localizedDescription)")
            } else {
                print("문서 삭제 성공")
            }
        }
        self.fetchReservation()
    }
    
    
    
    // MARK: - 예약 내역 삭제
    func deleteMyReservation(reservation: Reservation) {
        guard let email = Self.user!.email  else {
            print("로그인 한 유저의 email 정보가 없습니다.")
            return
        }
        
        let userDocRef = self.db.collection("User").document(email).collection("MyReservation").document(reservation.id)
        
        userDocRef.delete { error in
            if let error = error {
                print("문서 삭제 오류: \(error.localizedDescription)")
            } else {
                print("문서 삭제 성공")
            }
        }
        self.fetchReservation()
    }
    
    
    
    func dateTimeStringToDate(date: Date, time: Int) -> Date? {
        // Date 객체에서 시간 구성 요소 가져오기
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        // 시간 구성 요소의 시간 부분을 Int 타입의 시간으로 설정
        dateComponents.hour = time
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return calendar.date(from: dateComponents)
    }
    
    
    func isFinishedReservation(date: Date, time: Int) -> String {
        let reservationTime: Date? = self.dateTimeStringToDate(date: date, time: time)
        
        guard let reservationTime else {
            print("예약 시간 가져오기 실패")
            return "예약"
        }
        
        let currentDate = Date()
        
        // Calendar 객체를 사용하여 예약 시간과 현재 시간 간의 차이를 계산합니다.
        let calendar = Calendar.current
        guard let twoHoursLater = calendar.date(byAdding: .hour, value: 2, to: reservationTime) else {
            return "error"
        }
        if currentDate >= twoHoursLater {
            return "이용 완료"
        } else if currentDate > reservationTime && currentDate < twoHoursLater {
            return "이용 중"
        } else {
            // 아직 2시간이 지나지 않았으면 예약 시간을 출력합니다.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedReservationTime = dateFormatter.string(from: reservationTime)
            print("예약 시간: \(formattedReservationTime)")
            return "이용 전"
        }
    }
    
    
    
    // MARK: - Firestore에 등록하기 위한 타입 변환
    private func dateTimeStringToTimeStamp(reservationDate: Date, reservationHour: Int) -> Timestamp? {
        
        let date = dateTimeStringToDate(date: reservationDate, time: reservationHour)
        
        // Timestamp 생성
        if let combinedDate = date {
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
    private func timeStampTodateTime(data: [String : Any]) -> (Date, Int)? {
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
    
    // 네이버 예약을 보니까 페이지를 넘길 때 있는 시간대면, 괜찮지만, 아닐때는 저기함
    
    
    /// 예약가능한 시간을 배열로 리턴
    /// - Parameters:
    ///   - open: 오픈시간
    ///   - close: 마감시간
    ///   - date: 예약 날짜
    /// - Returns: 예약 가능 시간대
    func getAvailableTimeSlots(open: Int, close: Int, date: Date) -> [Int] {  
//        func getAvailableTimeSlots(open: Int, close: Int, reservationTime: Int) -> [Int] {
        // 브레이크 타임 적용 -> Shop 데이터 받아야 함
        // 예약된 타임은 disable 시키기
        let reservationDate: Date = date
        let openTime: Int = open
        let closeTime: Int = close
        
        if Calendar.current.isDateInToday(reservationDate) {
            let nowInt = Int("HH".stringFromDate())
            
            if let nowInt {
                // 현재 시간이 마감시간 1시간 전보다 같거나 늦으면 빈 배열 반환
                guard nowInt < closeTime - 1 else {
                    return []
                }
                
                // 현재 시간이 오픈시간 전이거나 같을 때
                guard nowInt >= openTime else {
                    let times = Array(openTime...closeTime - 1)
                    return times
                }
                
                // 오픈시간 ~ 마감시간 1시간 전일 때
                // 8시에 에러 남
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
    
    
    // 예약 시간을 오전/오후 x시로 바꿔줌
    func conversionReservedTime(time: Int) -> (String, Int) {
        let when = time > 11 ? "오후" : "오전"
        let hour = time > 12 ? time - 12 : time
        
        return (when, hour)
    }
    
}
