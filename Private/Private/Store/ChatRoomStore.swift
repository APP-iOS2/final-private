//
//  ChatRoomStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation

final class ChatRoomStore: ObservableObject {
    @Published var chatRoomList: [ChatRoom] = []
    
    init() {
        
    }
    
    static let chatRoom = ChatRoom(
        id: "",
        otherUser: UserStore.user,
        messages: [message]
    )
    
    static let message = Message(
        sender: "",
        content: "여기 어때?",
        timestamp: Date().timeIntervalSince1970
    )
}


