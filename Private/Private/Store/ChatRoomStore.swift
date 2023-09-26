//
//  ChatRoomStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation

final class ChatRoomStore: ObservableObject {
    @Published var chatRoomList: [ChatRoom] = []
    @Published var messageList: [Message] = []
    
    init() {
        chatRoomList.append(ChatRoomStore.chatRoom)
        messageList = ChatRoomStore.chatRoom.messages
    }
    
    static let chatRoom = ChatRoom(
        id: "",
        otherUser: UserStore.user,
        messages: message
    )
    
    static let message = [
        Message(
            sender: "나",
            content: "여기 어때?",
            timestamp: Date().timeIntervalSince1970
        ),
        Message(
            sender: "상대방",
            content: "좀 괜찮던데?",
            timestamp: Date().timeIntervalSince1970
        ),
        Message(
            sender: "나",
            content: "머먹음?",
            timestamp: Date().timeIntervalSince1970
        ),
        Message(
            sender: "상대방",
            content: "크림치즈파스타가 진짜 존맛이더라 꼭 먹어라 여기서 만약에 더 길어진다면?!?!?!?!?!!?!? 더 길어지냐??\n 줄바꿈도 되냐?",
            timestamp: Date().timeIntervalSince1970
        )
    ]
}


