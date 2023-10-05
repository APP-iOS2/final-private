//
//  UserStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI
import NMapsMap
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class UserStore: ObservableObject {
    @Published var user: User = User()
    @Published var follower: [User] = []
    @Published var following: [User] = []
    
    func createUser(user: User) {
        Firestore.firestore().collection("User")
            .document(user.email)
//            .setData(user.toDictionary())
            .setData(["email" : user.email,
                      "name" : user.name,
                      "nickname" : user.nickname,
                      "phoneNumber" : user.phoneNumber,
                      "profileImageURL" : user.profileImageURL,
                      "follower" : user.follower,
                      "following" : user.following,
                      "myFeed" : user.myFeed,
                      "savedFeed" : user.savedFeed,
                      "bookmark" : user.bookmark,
                      "chattingRoom" : user.chattingRoom,
                      "myReservation" : user.myReservation
                     ]
            )
        
        fetchCurrentUser(userEmail: user.email)
    }

    
    func updateUser(user: User) {
        Firestore.firestore().collection("User")
            .document(user.email)
            .updateData(["email" : user.email,
                      "name" : user.name,
                      "nickname" : user.nickname,
                      "phoneNumber" : user.phoneNumber,
                      "profileImageURL" : user.profileImageURL,
                      "follower" : user.follower,
                      "following" : user.following,
                      "myFeed" : user.myFeed,
                      "savedFeed" : user.savedFeed,
                      "bookmark" : user.bookmark,
                      "chattingRoom" : user.chattingRoom,
                      "myReservation" : user.myReservation
                     ]
            )
        
        fetchCurrentUser(userEmail: user.email)
    }
    
    func fetchCurrentUser(userEmail: String) {
        Firestore.firestore().collection("User").document(userEmail).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
            } else if let userData = snapshot?.data(), let user = User(document: userData) {
                self.user = user
            }
        }
    }

    func deleteUser(userEmail: String) {
        Firestore.firestore().collection("User")
            .document(user.email).delete()
    }
  
//    static let shopItem = ShopItem(item: "비빔밥", price: "10000", image: "")
  
//    static let user = User(
//        name: "맛집탐방러",
//        nickname: "Private",
//        phoneNumber: "010-0000-0000",
//        profileImageURL: "https://discord.com/channels/1087563203686445056/1153285554646036550/1154579593819344928",
//        follower: [],
//        following: [],
//        myFeed: [dummyFeed,dummyFeed1,dummyFeed2,dummyFeed3],
//        savedFeed: [],
//        bookmark: [
//            Shop(
//            name: "강남 맛집",
//            category: Category.koreanFood,
//            coord: NMGLatLng(lat: 36.444, lng: 127.332),
//            address: "서울시 강남구",
//            addressDetail: "7번 출구 어딘가",
//            shopTelNumber: "010-1234-5678",
//            shopInfo: "미슐랭 맛집",
//            shopImageURL: "https://img.daily.co.kr/@files/www.daily.co.kr/content/food/2020/20200730/40d0fb3794229958bdd1e36520a4440f.jpg",
//            shopItems: [shopItem],
//            numberOfBookmark: 0
//        ), Shop(
//            name: "강남 맛집2",
//            category: Category.koreanFood,
//            coord: NMGLatLng(lat: 36.4445, lng: 127.331),
//            address: "서울시 강남구",
//            addressDetail: "7번 출구 어딘가",
//            shopTelNumber: "010-1234-5678",
//            shopInfo: "미슐랭 맛집",
//            shopImageURL: "https://mblogthumb-phinf.pstatic.net/MjAxNzAzMjZfMTM5/MDAxNDkwNDYxMDM1NzE4.sdrUUcAQOXtk6xZ7FJcEyyq-7P9kbo9OJ-GdKuWMfcYg.F9ljFIbwPQ25fdCXYUvN8fbC0Aun5UhHjVq_JE3UJc8g.PNG.nydelphie/DSC03257.png?type=w800",
//            shopItems: [shopItem],
//            numberOfBookmark: 0
//        )
//        ],
//        chattingRoom: [],
//        myReservation: []
//    )

    static let dummyFeed = MyFeed(writer: "me", images: ["https://img.daily.co.kr/@files/www.daily.co.kr/content/food/2020/20200730/40d0fb3794229958bdd1e36520a4440f.jpg"], contents: "", visitedShop: "", category: [])
    static let dummyFeed1 = MyFeed(writer: "me", images: ["https://image.ohou.se/i/bucketplace-v2-development/uploads/cards/advices/166557187458549420.jpg?gif=1&w=480&webp=1"], contents: "", visitedShop: "", category: [])
    static let dummyFeed2 = MyFeed(writer: "me", images: ["https://mblogthumb-phinf.pstatic.net/MjAxNzAzMjZfMTM5/MDAxNDkwNDYxMDM1NzE4.sdrUUcAQOXtk6xZ7FJcEyyq-7P9kbo9OJ-GdKuWMfcYg.F9ljFIbwPQ25fdCXYUvN8fbC0Aun5UhHjVq_JE3UJc8g.PNG.nydelphie/DSC03257.png?type=w800"], contents: "", visitedShop: "", category: [])
    static let dummyFeed3 = MyFeed(writer: "me", images: ["https://mblogthumb-phinf.pstatic.net/MjAxNzAzMjZfMTM5/MDAxNDkwNDYxMDM1NzE4.sdrUUcAQOXtk6xZ7FJcEyyq-7P9kbo9OJ-GdKuWMfcYg.F9ljFIbwPQ25fdCXYUvN8fbC0Aun5UhHjVq_JE3UJc8g.PNG.nydelphie/DSC03257.png?type=w800"], contents: "", visitedShop: "", category: [])
}

