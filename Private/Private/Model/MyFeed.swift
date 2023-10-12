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
