//
//  ChatRoom.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct ChatRoom: Hashable {
    var otherUserName: String
    var otherUserNickname: String
    var otherUserProfileImage: String
    var messages: [Message]
    
    init(otherUserName: String,otherUserNickname: String,otherUserProfileImage: String, messages: [Message]) {
        self.otherUserName = otherUserName
        self.otherUserNickname = otherUserNickname
        self.otherUserProfileImage = otherUserProfileImage
        self.messages = messages
    }
    
    init?(document: [String: Any]) {
           guard
               let otherUserName = document["otherUserName"] as? String,
               let otherUserNickname = document["otherUserNickname"] as? String,
               let otherUserProfileImage = document["otherUserProfileImage"] as? String,
               let messages = document["messages"] as? [Message]
           else {
               return nil // 필수 필드가 없을 경우 초기화를 실패시킵니다.
           }
        self.otherUserName = otherUserName
        self.otherUserNickname = otherUserNickname
        self.otherUserProfileImage = otherUserProfileImage
        self.messages = messages
       }
}
