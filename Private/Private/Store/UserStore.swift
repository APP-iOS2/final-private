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
    @Published var myFeedList: [MyFeed] = []
    @Published var mySavedFeedList: [MyFeed] = []
    @Published var mySavedPlace: [MyFeed] = []

    @Published var mySavedPlaceList: [MyFeed] = []
    @Published var otherFeedList: [MyFeed] = []
    @Published var otherSavedFeedList: [MyFeed] = []
    @Published var otherSavedPlaceList: [MyFeed] = []
    
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
        Firestore.firestore().collection("User").document(userEmail).collection("MyFeed").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
            }
            self.myFeedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                return MyFeed(documentData: data)
            } ?? []
            self.myFeedList.sort{$0.createdAt < $1.createdAt}
        }
        Firestore.firestore().collection("User").document(userEmail).collection("SavedFeed").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
            }
            self.mySavedFeedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                return MyFeed(documentData: data)
            } ?? []
            self.mySavedFeedList.sort{$0.createdAt < $1.createdAt}
        }
        Firestore.firestore().collection("User").document(userEmail).collection("SavedPlace").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
            }
            self.mySavedPlaceList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                return MyFeed(documentData: data)
            } ?? []
            self.mySavedPlaceList.sort{$0.createdAt < $1.createdAt}
        }
    }
    
    func fetchotherUser(userEmail:String) {
        Firestore.firestore().collection("User").document(userEmail).collection("MyFeed").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
            }
            self.otherFeedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                return MyFeed(documentData: data)
            } ?? []
            self.otherFeedList.sort{$0.createdAt < $1.createdAt}
        }
        Firestore.firestore().collection("User").document(userEmail).collection("SavedFeed").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
            }
            self.otherSavedFeedList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                return MyFeed(documentData: data)
            } ?? []
            self.otherSavedFeedList.sort{$0.createdAt < $1.createdAt}
        }
        Firestore.firestore().collection("User").document(userEmail).collection("SavedPlace").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
            }
            self.otherSavedPlaceList = querySnapshot?.documents.compactMap { (queryDocumentSnapshot) -> MyFeed? in
                let data = queryDocumentSnapshot.data()
                return MyFeed(documentData: data)
            } ?? []
            self.otherSavedPlaceList.sort{$0.createdAt < $1.createdAt}
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
    func saveFeed(_ feed: MyFeed) {
        do {
            try
            Firestore.firestore().collection("User").document(user.email).collection("SavedFeed")
                .document("\(feed.images[0].suffix(32))")
                .setData(from:feed)
            
        } catch {
            print("Error bookMark Feed: \(error)")
        }
    }
    
    func createMarker() {
        
    }
//    func createUser(user: User) {
//        Firestore.firestore().collection("User")
//            .document(user.email)
////            .setData(user.toDictionary())
//            .setData(["email" : user.email,
//                      "name" : user.name,
//                      "nickname" : user.nickname,
//                      "phoneNumber" : user.phoneNumber,
//                      "profileImageURL" : user.profileImageURL,
//                      "follower" : user.follower,
//                      "following" : user.following,
//                      "myFeed" : user.myFeed,
//                      "savedFeed" : user.savedFeed,
//                      "bookmark" : user.bookmark,
//                      "chattingRoom" : user.chattingRoom,
//                      "myReservation" : user.myReservation
//                     ]
//            )
//        
//        fetchCurrentUser(userEmail: user.email)
//    }
  
    func deleteFeed(_ feed: MyFeed) {
        Firestore.firestore().collection("User").document(user.email)
            .collection("SavedFeed")
            .document("\(feed.images[0].suffix(32))")
            .delete()
    }

    func savePlace(_ feed: MyFeed) {
        Firestore.firestore().collection("User").document(user.email)
            .collection("SavedPlace")
            .document("\(feed.images[0].suffix(32))")
            .setData(["writerNickname": "",
                      "writerName": "",
                      "writerProfileImage": "\(feed.images[0].suffix(32))",
                      "images": feed.images,
                      "contents": "",
                      "title": feed.title,
                      "category": feed.category,
                      "address": feed.address,
                      "roadAddress": feed.roadAddress,
                      "mapx": feed.mapx,
                      "mapy": feed.mapy
                     ])
    }
    
    func deletePlace(_ feed: MyFeed) {
        Firestore.firestore().collection("User").document(user.email)
            .collection("SavedPlace")
            .document("\(feed.writerProfileImage)")
            .delete()
    }
    
}

