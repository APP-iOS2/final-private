//
//  Reservation.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct Reservation: Hashable {
    var id: String = UUID().uuidString
    var shopId: String
    var reservedUserId: String
    var date: Date  // 예약일
    var time: Int  // 예약시간
    var numberOfPeople: Int = 1  // 예약인원
    var totalPrice: Int   // 총 가격
    var requirement: String? // 요구사항
    
    var priceStr: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let result = numberFormatter.string(from: NSNumber(value: totalPrice))
        return(result! + "원")
    }
}
