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
    var shopOwner: String   // 대표자명
    var businessNumber: String  // 사업자번호
    var reservationItems: [ShopItem]?  // 예약항목
//    var numberOfBookmark: Int     // 실험용
    var bookmarks: [String]
    var menu: [ShopItem]
    var regularHoliday: [String] // 정기 휴무일
    var temporaryHoliday: [Date] // 특정 휴무일
    var breakTimeHours: [String: BusinessHours]  // 브레이크타임
    var weeklyBusinessHours: [String: BusinessHours]  // 영업시간
}

struct ShopItem: Hashable {
    var name: String
    var price: Int
    var imageUrl: String
}

struct BusinessHours: Hashable {
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int
}
extension Shop {
    init?(documentData: [String: Any]) {
        guard
            let name = documentData["name"] as? String,
            let categoryRawValue = documentData["category"] as? Int,
            let category = Category(rawValue: categoryRawValue),
            let coordData = documentData["coord"] as? [String: Any],
            let lat = coordData["lat"] as? Double,
            let lng = coordData["lng"] as? Double,
            let address = documentData["address"] as? String,
            let addressDetail = documentData["addressDetail"] as? String,
            let shopTelNumber = documentData["shopTelNumber"] as? String,
            let shopInfo = documentData["shopInfo"] as? String,
            let shopImageURL = documentData["shopImageURL"] as? String
        else {
            print("Failed to initialize Feed with shopdata: \(documentData)")
            return nil
        }
        
        self.name = name
        self.category = category
        self.coord = NMGLatLng(lat: lat, lng: lng)
        self.address = address
        self.addressDetail = addressDetail
        self.shopTelNumber = shopTelNumber
        self.shopInfo = shopInfo
        self.shopImageURL = shopImageURL
        
        // 여기서 나머지 프로퍼티들을 초기화해야 합니다.
        // 만약 Firestore에 해당 정보가 없다면 기본값이나 빈 배열, 빈 문자열 등을 할당하세요.
        self.bookmarks = documentData["bookmarks"] as? [String] ?? []
        self.menu = [] // 여기는 어떻게 초기화할지 명시해야 합니다.
        self.regularHoliday = documentData["regularHoliday"] as? [String] ?? []
        self.temporayHoliday = documentData["temporayHoliday"] as? [Date] ?? []
        self.breakTimeHours = documentData["breakTimeHours"] as? [String: BusinessHours] ?? [:]
        self.weeklyBusinessHours = documentData["weeklyBusinessHours"] as? [String: BusinessHours] ?? [:]
        self.reservationItems = [] // 여기도 적절한 초기화가 필요합니다.
    }
}
