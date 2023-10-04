//
//  MyFeed.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import Foundation

struct MyFeed: Identifiable, Hashable {
    
    let id: String = UUID().uuidString
    
    var writer: String
    var images: [String]
    var contents: String
    var createdAt: Double = Date().timeIntervalSince1970
    var visitedShop: String
    var category: [String]
}

enum MyCategory: Int, CaseIterable, Hashable {
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
