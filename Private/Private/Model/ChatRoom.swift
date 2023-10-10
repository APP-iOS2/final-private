//
//  ChatRoom.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct ChatRoom: Hashable {
    // var id: String  //삭제
    var otherUser: User
    var messages: [Message]
    
    init(otherUser: User, messages: [Message]) {
           self.otherUser = otherUser
           self.messages = messages
       }
    
    init?(document: [String: Any]) {
           guard
               let otherUserDict = document["otherUser"] as? [String: Any],
               let otherUser = User(document: otherUserDict),
               let messages = document["messages"] as? [Message]
           else {
               return nil // 필수 필드가 없을 경우 초기화를 실패시킵니다.
           }
           
           self.otherUser = otherUser
           self.messages = messages
       }
}
