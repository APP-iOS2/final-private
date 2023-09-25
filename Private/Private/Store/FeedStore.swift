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
        feedList.append(FeedStore.feed)
    }
    
    static let feed = Feed(
        writer: UserStore.user,
        images: ["userDefault"],
        contents: "데이트하기 좋은곳 찾으신다면 추천! 기본은하고 분위기가 좋음. 오므라이스도 맛있다.",
        visitedShop: ShopStore.shop,
        category: [Category.koreanFood]
    )
}
