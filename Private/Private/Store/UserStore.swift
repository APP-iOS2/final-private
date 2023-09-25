//
//  UserStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI
import NMapsMap

final class UserStore: ObservableObject {
    @Published var user: [User] = []
    @Published var follower: [User] = []
    @Published var following: [User] = []
    
    init() {
        user.append(UserStore.user)
    }
    static let shopItem = ShopItem(item: "비빔밥", price: "10000", image: "")

    static let user = User(
        name: "맛집탐방러",
        nickname: "Private",
        phoneNumber: "010-0000-0000",
        profileImageURL: "https://discord.com/channels/1087563203686445056/1153285554646036550/1154579593819344928",
        follower: [],
        following: [],
        myFeed: [],
        savedFeed: [],
        bookmark: [
            Shop(
            name: "강남 맛집",
            category: Category.koreanFood,
            coord: NMGLatLng(lat: 36.444, lng: 127.332),
            address: "서울시 강남구",
            addressDetail: "7번 출구 어딘가",
            shopTelNumber: "010-1234-5678",
            shopInfo: "미슐랭 맛집",
            shopImageURL: "",
            shopItems: [shopItem],
            numberOfBookmark: 0
        ), Shop(
            name: "강남 맛집2",
            category: Category.koreanFood,
            coord: NMGLatLng(lat: 36.4445, lng: 127.331),
            address: "서울시 강남구",
            addressDetail: "7번 출구 어딘가",
            shopTelNumber: "010-1234-5678",
            shopInfo: "미슐랭 맛집",
            shopImageURL: "",
            shopItems: [shopItem],
            numberOfBookmark: 0
        )
        ],
        chattingRoom: [],
        myReservation: []
    )
}

