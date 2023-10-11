//
//  Shop.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI
import NMapsMap

struct Shop: Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var category: Category
    var coord: CodableNMGLatLng    // NMGLatLng 타입을 Codable하게 할 수 없어서 새로 만듦
    var address: String
    var addressDetail: String
    var shopTelNumber: String
    var shopInfo: String
    var shopImageURL: String
    var shopOwner: String   // 대표자명
    var businessNumber: String  // 사업자번호
    var reservationItems: [ShopItem]?  // 예약항목
    var bookmarks: [String]
    var menu: [ShopItem]
    var regularHoliday: [String] // 정기 휴무일
    var temporaryHoliday: [Date] // 특정 휴무일
    var breakTimeHours: [String: BusinessHours]  // 브레이크타임
    var weeklyBusinessHours: [String: BusinessHours]  // 영업시간
}

struct ShopItem: Codable, Hashable {
    var name: String
    var price: Int
    var imageUrl: String
}

struct BusinessHours: Codable, Hashable {
    var startHour: Int
    var startMinute: Int
    var endHour: Int
    var endMinute: Int
}

struct CodableNMGLatLng: Codable, Hashable {
    var lat: Double
    var lng: Double
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
            let shopImageURL = documentData["shopImageURL"] as? String,
            let shopOwner = documentData["shopOwner"] as? String,
            let businessNumber = documentData["businessNumber"] as? String
        else {
            print("Failed to initialize Shop with data: \(documentData)")
            return nil
        }
        
        // 기본 프로퍼티 초기화
        self.name = name
        self.category = category
        self.coord = CodableNMGLatLng(lat: lat, lng: lng)
        self.address = address
        self.addressDetail = addressDetail
        self.shopTelNumber = shopTelNumber
        self.shopInfo = shopInfo
        self.shopImageURL = shopImageURL
        self.shopOwner = shopOwner
        self.businessNumber = businessNumber

        // 나머지 프로퍼티 초기화
        self.bookmarks = documentData["bookmarks"] as? [String] ?? []
        self.menu = [] // 여기는 어떻게 초기화할지 명시해야 함
        self.regularHoliday = documentData["regularHoliday"] as? [String] ?? []
        self.temporaryHoliday = documentData["temporaryHoliday"] as? [Date] ?? []
        self.breakTimeHours = documentData["breakTimeHours"] as? [String: BusinessHours] ?? [:]
        self.weeklyBusinessHours = documentData["weeklyBusinessHours"] as? [String: BusinessHours] ?? [:]
        self.reservationItems = [] // 여기도 적절한 초기화가 필요.

        // menu와 reservationItems 초기화
        if let menuData = documentData["menu"] as? [[String: Any]] {
            self.menu = menuData.compactMap { ShopItem(documentData: $0) }
        } else {
            self.menu = []
        }

        if let reservationItemsData = documentData["reservationItems"] as? [[String: Any]] {
            self.reservationItems = reservationItemsData.compactMap { ShopItem(documentData: $0) }
        } else {
            self.reservationItems = nil
        }
    }
}


extension ShopItem {
    init?(documentData: [String: Any]) {
        guard
            let name = documentData["name"] as? String,
            let price = documentData["price"] as? Int,
            let imageUrl = documentData["imageUrl"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.price = price
        self.imageUrl = imageUrl
    }
}


//extension NMGLatLng: Codable {
//    public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encode("\(self.lat),\(self.lng)")
//        }
//    
//    public convenience init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let coordinates = try container.decode(String.self).split(separator: ",").compactMap { Double($0) }
//        guard coordinates.count == 2 else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid coordinates")
//        }
//        self.init(lat: coordinates[0], lng: coordinates[1])
//    }
//}
