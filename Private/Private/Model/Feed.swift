//
//  Feed.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct Feed {
    let id: String = UUID().uuidString
    var writer: User
    var images: [String]
    var contents: String
    var createdAt: Double = Date().timeIntervalSince1970
    var visitedShop: Shop
    var category: [Category]
}

enum Category: Int, CaseIterable {
    case koreanFood
    case westernFood
    case japaneseFood
    case chinessFood
    case dessert
    case pub
    case brunch
    case cafe

    var categoryName: String {
        switch self {
        case .koreanFood : return "한식"
        case .westernFood : return "양식"
        case .japaneseFood : return "일식"
        case .chinessFood : return "중식"
        case .dessert : return "디저트"
        case .pub : return "술집"
        case .brunch : return "브런치"
        case .cafe : return "카페"
        }
    }
}
