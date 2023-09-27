//
//  ReservationStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift   //GeoPoint 사용을 위한 프레임워크

final class ReservationStore: ObservableObject {
    @Published var reservationList: [Reservation] = []
    
    init() {
        
    }
    
    
    /// Double 타입의 날짜를 String으로 변형.
    /// 만약, 예약 날짜가 오늘이면 오늘(요일) 형태로 바꿔줌
    func getReservationDate() -> String {
        let reservationDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")  // 요일을 한국어로 얻기 위해 로케일 설정
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = dateFormatter.string(from: reservationDate)
        return dateString
    }
    
    
    // MARK: - 예약 등록
//    func createReservation(reservationData: Reservation) async {
//        do {
//            let documents = Firestore.firestore().collection("Reservation")
//            try await documents.document(reservationData.id)
//                .setData(["shopId": ,
//                          "reservedUserId": ,
//                            "date": Date.now,   // date에 시간까지 합쳐서 보냄(Timestamp타입?)
//                          "numberOfPeople": reservationData.numberOfPeople,
//                          "totalPrice": ,
//                          "requirement": ])
//
//
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
}
