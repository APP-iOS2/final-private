//
//  Reservation.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct Reservation {
    var id: String = UUID().uuidString
    var shopId: String
    var reservedUserId: String
    var date: Date  // 예약일
    var time: Int  // 예약시간
    var numberOfPeople: Int  // 예약인원
    var totalPrice: Int   // 총 가격
    var requirement: String? // 요구사항
}
