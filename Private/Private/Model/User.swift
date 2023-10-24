//
//  User.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation
import Firebase

struct User: Identifiable, Hashable, Equatable {
    let id: String = UUID().uuidString
    let email: String
    var name: String
    var nickname: String
    var phoneNumber: String
    var profileImageURL: String
    var follower: [String]
    var following: [String]
    var myFeed: [String]
    var savedFeed: [Feed]
    var bookmark: [String]
    var chattingRoom: [ChatRoom]
    var myReservation: [Reservation]
    
    init?(document: [String: Any]) {
           guard
               let name = document["name"] as? String,
               let email = document["email"] as? String,
               let nickname = document["nickname"] as? String,
               let phoneNumber = document["phoneNumber"] as? String,
               let profileImageURL = document["profileImageURL"] as? String,
               let follower = document["follower"] as? [String],
               let following = document["following"] as? [String],
               let myFeed = document["myFeed"] as? [String],
               let savedFeed = document["savedFeed"] as? [Feed],
               let bookmark = document["bookmark"] as? [String],
               let chattingRoom = document["chattingRoom"] as? [ChatRoom],
               let myReservation = document["myReservation"] as? [Reservation]
               // 다른 필드들에 대한 추출 작업을 추가합니다.
           else {
               return nil // 필수 필드가 없을 경우 초기화를 실패시킵니다.
           }
      
        self.email = email
        self.name = name
        self.nickname = nickname
        self.phoneNumber = phoneNumber
        self.profileImageURL = profileImageURL
        self.follower = follower
        self.following = following
        self.myFeed = myFeed
        self.savedFeed = savedFeed
        self.bookmark = bookmark
        self.chattingRoom = chattingRoom
        self.myReservation = myReservation
    }
    
    init() {
        self.email = ""
        self.name = ""
        self.nickname = ""
        self.phoneNumber = ""
        self.profileImageURL = ""
        self.follower = []
        self.following = []
        self.myFeed = []
        self.savedFeed = []
        self.bookmark = []
        self.chattingRoom = []
        self.myReservation = []
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.nickname == rhs.nickname
    }
    
    func toDictionary() -> [String: Any] {
           return ["email": email,
                   "name": name,
                   "nickname": nickname,
                   "phoneNumber": phoneNumber,
                   "profileImageURL": profileImageURL,
                   "follower": follower,
                   "following": following,
                   "myFeed": myFeed,
                   "savedFeed": savedFeed,
                   "bookmark": bookmark,
                   "chattingRoom": chattingRoom,
                   "myReservation": myReservation
                  ]
       }
}

