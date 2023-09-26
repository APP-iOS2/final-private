//
//  ReservationStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation

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
    
//    static var reservation = Reservation(shopId: ShopStore.shop.id,
//                                         reservedUserId: UserStore.user.id,
//                                         date: Date(),
//                                         time: 18,
//                                         numberOfPeople: 4,
//                                         totalPrice: 30000)
}
