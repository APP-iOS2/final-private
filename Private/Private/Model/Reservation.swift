//
//  Reservation.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct Reservation {
    var shop: Shop
    var date: Double  // 예약일
    var time: String  // 예약시간
    var isOpen: Bool
    var numberOfPeople: Int  // 예약인원
    var totalPrice: String   // 총 가격
    var reservedUser: User   // 예약자
    
//    var breakTime: [String]
    // 뭐에 대한 예약인지 - 아이템
    /*
     브레이크 타임은
     */
    // 휴일[배열] (매주 일요일 / 빨간날)
}
