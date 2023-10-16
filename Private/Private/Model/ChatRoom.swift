//
//  ChatRoom.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct ChatRoom: Hashable {
    var firstUserNickname: String
    var firstUserProfileImage: String
    var secondUserNickname: String
    var secondUserProfileImage: String
    
    
    init(firstUserNickname: String, firstUserProfileImage: String, secondUserNickname: String, secondUserProfileImage: String) {
        self.firstUserNickname = firstUserNickname
        self.firstUserProfileImage = firstUserProfileImage
        self.secondUserNickname = secondUserNickname
        self.secondUserProfileImage = secondUserProfileImage
    }
    
    
    init?(document: [String: Any]) {
           guard
               let firstUserNickname = document["firstUserNickname"] as? String,
               let firstUserProfileImage = document["firstUserProfileImage"] as? String,
               let secondUserNickname = document["secondUserNickname"] as? String,
               let secondUserProfileImage = document["secondUserProfileImage"] as? String
           else {
               return nil // 필수 필드가 없을 경우 초기화를 실패시킵니다.
           }
        self.firstUserNickname = firstUserNickname
        self.firstUserProfileImage = firstUserProfileImage
        self.secondUserNickname = secondUserNickname
        self.secondUserProfileImage = secondUserProfileImage
       }
}
