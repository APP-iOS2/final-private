//
//  UserStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI

final class UserStore: ObservableObject {
    @Published var user: [User] = []
    @Published var follower: [User] = []
    @Published var following: [User] = []
    
    init() {
    }
    
    static let user = User(
        name: "맛집탐방러",
        nickname: "Private",
        phoneNumber: "010-0000-0000",
        profileImageURL: "https://discord.com/channels/1087563203686445056/1153285554646036550/1154579593819344928",
        follower: [],
        following: [],
        myFeed: [dummyFeed,dummyFeed1,dummyFeed2,dummyFeed3],
        savedFeed: [],
        bookmark: [],
        chattingRoom: [],
        myReservation: []
    )
    static let dummyFeed = MyFeed(writer: "me", images: ["https://img.daily.co.kr/@files/www.daily.co.kr/content/food/2020/20200730/40d0fb3794229958bdd1e36520a4440f.jpg"], contents: "", visitedShop: ShopStore.shop, category: [MyCategory.brunch])
    static let dummyFeed1 = MyFeed(writer: "me", images: ["https://image.ohou.se/i/bucketplace-v2-development/uploads/cards/advices/166557187458549420.jpg?gif=1&w=480&webp=1"], contents: "", visitedShop: ShopStore.shop, category: [MyCategory.brunch])
    static let dummyFeed2 = MyFeed(writer: "me", images: ["https://mblogthumb-phinf.pstatic.net/MjAxNzAzMjZfMTM5/MDAxNDkwNDYxMDM1NzE4.sdrUUcAQOXtk6xZ7FJcEyyq-7P9kbo9OJ-GdKuWMfcYg.F9ljFIbwPQ25fdCXYUvN8fbC0Aun5UhHjVq_JE3UJc8g.PNG.nydelphie/DSC03257.png?type=w800"], contents: "", visitedShop: ShopStore.shop, category: [MyCategory.brunch])
    static let dummyFeed3 = MyFeed(writer: "me", images: ["https://mblogthumb-phinf.pstatic.net/MjAxNzAzMjZfMTM5/MDAxNDkwNDYxMDM1NzE4.sdrUUcAQOXtk6xZ7FJcEyyq-7P9kbo9OJ-GdKuWMfcYg.F9ljFIbwPQ25fdCXYUvN8fbC0Aun5UhHjVq_JE3UJc8g.PNG.nydelphie/DSC03257.png?type=w800"], contents: "", visitedShop: ShopStore.shop, category: [MyCategory.brunch])
}

