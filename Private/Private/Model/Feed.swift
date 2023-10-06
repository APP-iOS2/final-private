//
//  Feed.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation
import Firebase


struct Feed: Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    
    var writer: User
    var images: [String]
    var contents: String
    var createdAt: Double = Date().timeIntervalSince1970
    var visitedShop: Shop
    var category: [Category]
}

enum Category: Int, CaseIterable, Hashable {
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

extension Feed {
    init?(documentData: [String: Any]) {
        guard
            let visitedShopData = documentData["visitedShop"] as? [String: Any],
            let visitedShop = Shop(documentData: visitedShopData),
            let writerData = documentData["writer"] as? [String: Any],
            let writer = User(document: writerData), // User 초기화 메서드도 구현해야함.
            let contents = documentData["contents"] as? String,
            let images = documentData["images"] as? [String],
            let createdAt = documentData["createdAt"] as? Timestamp, // Firestore의 Timestamp를 사용
            let categoryData = documentData["category"] as? [String]
        else {
            print("Failed to initialize Feed with feeddata: \(documentData)")
            return nil
        }
        
        // 여기서 나머지 프로퍼티들을 초기화해야 합니다.
        self.visitedShop = visitedShop
        self.writer = writer
        self.contents = contents
        self.images = images
        //self.createdAt = createdAt.dateValue() // Firestore Timestamp를 Swift Date로 변환
        self.createdAt = createdAt.dateValue().timeIntervalSince1970
        //self.category = categoryData.compactMap { Category(rawValue: $0) }
        //compactMap 를 사용해 String ->Int -> Category 타입으로 변환하였다
        self.category = categoryData.compactMap { categoryName in
            if let intValue = Int(categoryName) {
                return Category(rawValue: intValue)
            } else {
                // String을 Int로 변환하는 데 실패했습니다.
                print("Failed to :String을 Int로 변환하는 데 실패했습니다.")
                return nil
            }
        }

    }
}
