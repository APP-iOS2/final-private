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
}
