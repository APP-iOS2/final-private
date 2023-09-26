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
    
//    static let reservation = Reservation(
//        shop: ShopStore.shop,
//        date: Date().timeIntervalSince1970,
//        time: "",
//        isOpen: true,
//        numberOfPeople: 4,
//        totalPrice: ShopStore.shop.shopItems[0].price,
//        reservedUser: UserStore.user
//    )
}
