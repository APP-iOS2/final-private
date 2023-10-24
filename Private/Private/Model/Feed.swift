//
//  Feed.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Feed: Identifiable, Codable, Hashable {
    
    var id: String = UUID().uuidString
    
    var writerNickname: String
    var writerName: String
    var writerProfileImage: String
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

enum Category: Int, CaseIterable, Hashable, Codable {
    case general
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
        case .general: return "전체"
        case .koreanFood: return "한식"
        case .westernFood: return "양식"
        case .japaneseFood: return "일식"
        case .chinessFood: return "중식"
        case .dessert: return "디저트"
        case .pub: return "술집"
        case .brunch: return "브런치"
        case .cafe: return "카페"
        }
    }
    
    static var filteredCases: [Category] {
        return allCases.filter { $0 != .general }
    }
}
