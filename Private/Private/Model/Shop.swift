//
//  Shop.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI
import NMapsMap

struct Shop: Hashable {
    let id: String = UUID().uuidString
    var name: String
    var category: Category
    var coord: NMGLatLng
    var address: String
    var addressDetail: String
    var shopTelNumber: String
    var shopInfo: String
    var shopImageURL: String
    var reservationItems: [ShopItem]?  // 예약항목
//    var numberOfBookmark: Int     // 실험용
    var bookmarks: [String]
    var menu: [ShopItem]
    var regularHoliday: [String] // 정기 휴무일
    var temporayHoliday: [Date] // 특정 휴무일
    var breakTimeHours: [String: BusinessHours]  // 브레이크타임
    var weeklyBusinessHours: [String: BusinessHours]  // 영업시간
}

struct ShopItem {
    var name: String
    var price: Int
    var imageUrl: String
}

struct BusinessHours {
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int
}


