//
//  MyFeed.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import Foundation

struct MyFeed: Identifiable, Codable, Hashable {
    
    var id: String = UUID().uuidString
    
    var writer: String
    var images: [String]
    var contents: String
    var createdAt: Double = Date().timeIntervalSince1970
    var title: String
    var category: [String]
    var address: String
    var roadAddress: String
    var mapx: String
    var mapy: String

}
enum MyCategory: String, CaseIterable, Hashable, Codable {
    case koreanFood = "한식"
    case westernFood = "양식"
    case japaneseFood = "일식"
    case chinessFood = "중식"
    case dessert = "디저트"
    case pub = "술집"
    case brunch = "브런치"
    case cafe = "카페"
}
