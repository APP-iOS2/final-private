//
//  Reservation.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct Reservation {
    var shop: Shop
    var date: Date
    var time: String
    var isOpen: Bool
    var numberOfPeople: Int
    var totalPrice: String
    var reservedUser: User
}
