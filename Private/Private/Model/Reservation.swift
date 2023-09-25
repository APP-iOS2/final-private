//
//  Reservation.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct Reservation {
    var shop: Shop
    var date: Double
    var time: String
    var isOpen: Bool
    var numberOfPeople: Int
    var totalPrice: String
    var reservedUser: User
    // 뭐에 대한 예약인지 - 아이템
    // 브레이크 타임
    // 휴일[배열]
}
