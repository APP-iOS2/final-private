//
//  FeedStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation

final class FeedStore: ObservableObject {
    @Published var feedList: [Feed] = []
    
    init() {
        
    }
    
    static let feed = Feed(
        writer: UserStore.user,
        images: [""],
        contents: "맛있는 맛집이에요",
        visitedShop: ShopStore.shop,
        category: [Category.koreanFood]
    )
}
