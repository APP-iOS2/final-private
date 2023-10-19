//
//  MyFeed.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import Foundation

struct MyFeed: Identifiable, Codable, Hashable {
    
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
    
    var createdDate: String {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: Date(timeIntervalSince1970: createdAt), to: currentDate)
        
        if let year = components.year, year > 0 {
            return "\(year)년 전"
        } else if let month = components.month, month > 0 {
            return "\(month)개월 전"
        } else if let week = components.weekOfYear, week > 0 {
            return "\(week)주 전"
        } else if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }
}

enum MyCategory: Int, CaseIterable, Hashable, Codable {
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
}
extension MyFeed {
    init?(documentData: [String: Any]) {
        guard
            let writerNickname = documentData["writerNickname"] as? String,
            let writerName = documentData["writerName"] as? String,
            let writerProfileImage = documentData["writerProfileImage"] as? String,
            let images = documentData["images"] as? [String],
            let contents = documentData["contents"] as? String,
            let title = documentData["title"] as? String,
            let category = documentData["category"] as? [String],
            let address = documentData["address"] as? String,
            let roadAddress = documentData["roadAddress"] as? String,
            let mapx = documentData["mapx"] as? String,
            let mapy = documentData["mapy"] as? String
  
        else {
            return nil
        }
        
        self.writerNickname = writerNickname
        self.writerName = writerName
        self.writerProfileImage = writerProfileImage
        self.images = images
        self.contents = contents
        self.title = title
        self.category = category
        self.address = address
        self.roadAddress = roadAddress
        self.mapx = mapx
        self.mapy = mapy
        
    }
    
    init() {
        self.writerNickname = ""
        self.writerName = ""
        self.writerProfileImage = ""
        self.images = []
        self.contents = ""
        self.title = ""
        self.category = []
        self.address = ""
        self.roadAddress = ""
        self.mapx = ""
        self.mapy = ""
    }
}
