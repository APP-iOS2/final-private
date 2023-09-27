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
    
    init() {
        
    }
    
    /// Double 타입의 날짜를 String으로 변형
    /// 만약, 예약 날짜가 오늘이면 오늘(요일) 형태로 바꿔줌
    func getReservationDate(reservationDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")  // 요일을 한국어로 얻기 위해 로케일 설정

        if Calendar.current.isDateInToday(reservationDate) {
            // 예약 날짜가 오늘일 경우
            dateFormatter.dateFormat = "오늘(E)" // 요일을 표시하는 형식으로 설정
        } else {
            dateFormatter.dateFormat = "MM월 dd일"  // yyyy년을 붙이는게 나은지
        }

        let dateString = dateFormatter.string(from: reservationDate)
        return dateString
    }

    
    /// ReservationList에 추가하기
    /// - Parameter tempReservation: 임시 예약 데이터
    func appendReservationList(tempReservation: Reservation) {
        let reservationData = tempReservation
        // tempReservation.shopId =  // 뷰 넘길 때 받아오기
        // tempReservation.reservedUserId =   // 현재로그인한 유저의 id
        
        self.reservationList.append(reservationData)
    }
    
    // 예약 조회 / 등록 / 수정 / 삭제 3개는 있어야 함
    
    

    
    /// Firestore Database에 예약내용 올리기
    /// - Parameter reservationData: 예약 데이터
    func addReservationToFirestore(reservationData: Reservation) {
        let documentRef = db.collection("Reservation").document(reservationData.id)
        
        let dateTimestamp: Timestamp = dateTimeStringToTimeStamp(reservationDate: reservationData.date, reservationHour: reservationData.time)
        
        let reservationData: [String: Any] = [
            "shopId": reservationData.shopId,
            "reservedUserId": reservationData.reservedUserId,
            "date": dateTimestamp,
            "numberOfPeople": reservationData.numberOfPeople,
            "totalPrice": reservationData.totalPrice,
            "requirement": reservationData.requirement ?? "요구사항 없음"
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
    
    
    
    /// Date 타입의 날짜와 Int 타입의 시간을 Timestamp 타입으로 리턴해줌
    /// - Parameters:
    ///   - reservationDate: 예약 날짜(Date)
    ///   - reservationHour: 예약 시간(Int)
    func dateTimeStringToTimeStamp(reservationDate: Date, reservationHour: Int) -> Timestamp {
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
            print("Combined Timestamp: \(timestamp)")
            return timestamp
        } else {
            print("Timestamp를 생성할 수 없습니다.")
            return Timestamp(date: Date())
        }
    }
    
    
    
    
    // 논리
    /*
     로컬에 있는 임시예약에 값을 넣음
     확정하면, 임시값을 스토어에 넣음
     스토어에 넣은 값을 파베에 올림!
     */
    
    // 예약 파베에 올리기
    /*
     1. id를 document로 사용
     2. date와 time을 timeStamp로 합쳐서 올리기 (받을 때는 반대루~)
     3. requirement는 옵셔널이니까 잘 처리해서 사용할 것
     */

    
    
 
}
