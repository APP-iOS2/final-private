//
//  Feed.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Feed: Identifiable, Hashable {
    
    let id: String = UUID().uuidString
    
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
        self.contents = documentData["contents"] as? String ?? ""
        
        let visitedShopData = documentData["visitedShop"] as? [String: Any] ?? [:]
        
        guard let visitedShop = Shop(documentData: visitedShopData) else {
            return nil
        }
        self.visitedShop = visitedShop
        
        let writerData = documentData["writer"] as? [String: Any] ?? [:]
        self.writer = User(document: writerData) ?? User()
        
        self.images = documentData["images"] as? [String] ?? []
        
        if let createdAtTimestamp = documentData["createdAt"] as? Timestamp {
            self.createdAt = createdAtTimestamp.dateValue().timeIntervalSince1970
        } else {
            self.createdAt = Date().timeIntervalSince1970
        }
        
        let categoryData = documentData["category"] as? [Int] ?? []
        self.category = categoryData.compactMap(Category.init(rawValue:))
    }
}


/*
extension Feed {

init?(documentData: [String: Any]) {
    self.contents = documentData["contents"] as? String ?? ""
    
    let visitedShopData = documentData["visitedShop"] as? [String: Any] ?? [:]
    // 옵셔널 Shop 인스턴스를 안전하게 처리하거나, 빈 딕셔너리를 사용하여 기본 Shop 인스턴스를 생성합니다.
    //self.visitedShop = Shop(documentData: visitedShopData) ?? Shop(documentData: [String : Any])  // Shop에 기본 이니셜라이저가 필요합니다.
    self.visitedShop = Shop(documentData: visitedShopData) ?? Shop(documentData: [:])
    // "writer" 키에 대한 값을 사전으로 추출하거나, 값이 없으면 빈 사전으로 설정합니다.
    let writerData = documentData["writer"] as? [String: Any] ?? [:]
    // writerData를 사용하여 User 인스턴스를 생성하거나, 실패하면 기본 User 인스턴스를 생성합니다.
    self.writer = User(document: writerData) ?? User()  // User에 기본 이니셜라이저가 필요합니다.
    
    // "images" 키에 대한 값을 문자열 배열로 추출하거나, 값이 없으면 빈 배열로 설정합니다.
    self.images = documentData["images"] as? [String] ?? []
    
    // "createdAt" 키에 대한 값을 Timestamp로 추출합니다.
    if let createdAtTimestamp = documentData["createdAt"] as? Timestamp {
        // Timestamp를 사용하여 초 단위의 시간으로 변환합니다.
        self.createdAt = createdAtTimestamp.dateValue().timeIntervalSince1970
    } else {
        // 값이 없으면 현재 시간으로 설정합니다.
        self.createdAt = Date().timeIntervalSince1970
    }
    
    // "category" 키에 대한 값을 Int 배열로 추출하거나, 값이 없으면 빈 배열로 설정합니다.
    let categoryData = documentData["category"] as? [Int] ?? []
    // 각 Int를 Category로 변환하거나, 변환에 실패하면 무시합니다.
    self.category = categoryData.compactMap(Category.init(rawValue:))
    }
}

//extension Feed {
// 이 초기화 메서드는 사전에서 Feed 인스턴스를 생성하는 데 사용됩니다.
init?(documentData: [String: Any]) {
    // "contents" 키에 대한 값을 String으로 추출하거나, 값이 없으면 빈 문자열로 설정합니다.
    self.contents = documentData["contents"] as? String ?? ""
    
    // "visitedShop" 키에 대한 값을 사전으로 추출하거나, 값이 없으면 빈 사전으로 설정합니다.
    let visitedShopData = documentData["visitedShop"] as? [String: Any] ?? [:]
    // visitedShopData를 사용하여 Shop 인스턴스를 생성하거나, 실패하면 기본 Shop 인스턴스를 생성합니다.
    self.visitedShop = Shop(documentData: visitedShopData) ?? Shop(documentData: [String : Any])  // Shop에 기본 이니셜라이저가 필요합니다.
  
    // "writer" 키에 대한 값을 사전으로 추출하거나, 값이 없으면 빈 사전으로 설정합니다.
    let writerData = documentData["writer"] as? [String: Any] ?? [:]
    // writerData를 사용하여 User 인스턴스를 생성하거나, 실패하면 기본 User 인스턴스를 생성합니다.
    self.writer = User(document: writerData) ?? User()  // User에 기본 이니셜라이저가 필요합니다.
    
    // "images" 키에 대한 값을 문자열 배열로 추출하거나, 값이 없으면 빈 배열로 설정합니다.
    self.images = documentData["images"] as? [String] ?? []
    
    // "createdAt" 키에 대한 값을 Timestamp로 추출합니다.
    if let createdAtTimestamp = documentData["createdAt"] as? Timestamp {
        // Timestamp를 사용하여 초 단위의 시간으로 변환합니다.
        self.createdAt = createdAtTimestamp.dateValue().timeIntervalSince1970
    } else {
        // 값이 없으면 현재 시간으로 설정합니다.
        self.createdAt = Date().timeIntervalSince1970
    }
    
    // "category" 키에 대한 값을 Int 배열로 추출하거나, 값이 없으면 빈 배열로 설정합니다.
    let categoryData = documentData["category"] as? [Int] ?? []
    // 각 Int를 Category로 변환하거나, 변환에 실패하면 무시합니다.
    self.category = categoryData.compactMap(Category.init(rawValue:))
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
         // 여기서 나머지 프로퍼티들을 초기화
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
*/
