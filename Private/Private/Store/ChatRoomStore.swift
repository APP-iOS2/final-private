//
//  ChatRoomStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation
import FirebaseFirestore

final class ChatRoomStore: ObservableObject {
    @Published var chatRoomList: [ChatRoom] = []
    @Published var messageList: [Message] = []
    
//    @EnvironmentObject var userStore: UserStore

    func subscribeToChatRoomChanges(user: User) {
        print("email")
        print(user.email)
        let userCollection = Firestore.firestore().collection("User")
        let subCollection = userCollection.document(user.email).collection("chattingRoom")

        subCollection.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error listening for chat room changes: \(error?.localizedDescription ?? "")")
                return
            }

            var chatRooms: [ChatRoom] = []

            for document in documents {
                guard let chattingRooms = document.data()["chattingRoom"] as? [[String : Any]] else {
                    print("chattingRoom is nil")
                    continue
                }

                for chatRoomData in chattingRooms {
                    guard let otherUserDict = chatRoomData["otherUser"] as? [String: Any],
                          let otherUser = User(document: otherUserDict),
                          let messagesData = chatRoomData["messages"] as? [[String: Any]] else {
                        print("Invalid chat room data")
                        continue
                    }

                    var messages: [Message] = []

                    for messageData in messagesData {
                        guard let sender = messageData["sender"] as? String,
                              let content = messageData["content"] as? String,
                              let timestamp = messageData["timestamp"] as? Double else {
                            print("Invalid message data")
                            continue
                        }

                        // Message 객체 생성 및 배열에 추가
                        let message = Message(sender: sender, content: content, timestamp: timestamp)
                        messages.append(message)
                    }

                    // ChatRoom 객체 생성 및 chatRooms 배열에 추가
                    let chatRoom = ChatRoom(otherUser: otherUser, messages: messages)
                    chatRooms.append(chatRoom)
                }
            }
            
            // 새로운 채팅방 목록을 사용하여 필요한 작업 수행
            
        }
    }
    
    //chatRoom추가
//    func addChatRoomToUser(user: User, chatRoom: ChatRoom) {
//        let userCollection = Firestore.firestore().collection("User")
//        let subCollection = userCollection.document(user.email).collection("chattingRoom")
//
//        // ChatRoom 데이터 생성
//        let chatRoomData: [String: Any] = [
//            "otherUser": chatRoom.otherUser.toDictionary(),  // 다른 사용자 정보
//            "messages": chatRoom.messages.map { $0.toDictionary() }  // 메시지들의 배열
//        ]
//
//        // chattingRooms 컬렉션에 채팅방 데이터 추가
//        subCollection.addDocument(data: ["chattingRoom": [chatRoomData]]) { error in
//            if let error = error {
//                print("Error adding chat room to user: \(error.localizedDescription)")
//            } else {
//                print("Chat room added to user successfully")
//            }
//        }
//    }
    
    func addChatRoomToUser(user: User, chatRoom: ChatRoom) {
        let userCollection = Firestore.firestore().collection("User")
        let subCollection = userCollection.document(user.email).collection("chattingRoom")

        // ChatRoom 데이터 생성
        var chatRoomData: [String: Any] = [:]
        
        if let otherUserDict = userToDictionary(user: chatRoom.otherUser) {
            chatRoomData["otherUser"] = otherUserDict
        } else {
            print("Invalid other user data")
            return
        }
        
        var messagesData: [[String: Any]] = []
        
        for message in chatRoom.messages {
            if let messageDict = messageToDictionary(message) {
                print("messageDict:\(messageDict)")
                messagesData.append(messageDict)
            } else {
                print("Invalid message data")
                return
            }
        }
        
        chatRoomData["messages"] = messagesData

        // chattingRooms 컬렉션에 채팅방 데이터 추가
        subCollection.addDocument(data: ["chattingRoom": [chatRoomData]]) { error in
            if let error = error {
                print("Error adding chat room to user: \(error.localizedDescription)")
            } else {
                print("chatRoomData::\(chatRoomData)")
                print("Chat room added to user successfully")
            }
        }
    }

    // User 객체를 딕셔너리로 변환하는 함수
    func userToDictionary(user: User) -> [String: Any]? {
       // User 객체의 속성들을 딕셔너리 형태로 매핑하여 반환하도록 구현해야 합니다.
       // 예시:
       return [
           "email": user.email,
           "name": user.name,
           // 추가적인 속성들...
       ]
    }

    // Message 객체를 딕셔너리로 변환하는 함수
    func messageToDictionary(_ message: Message) -> [String: Any]? {
       // Message 객체의 속성들을 딕셔너리 형태로 매핑하여 반환하도록 구현해야 합니다.
       // 예시:
       return [
           "sender": message.sender,
           "content": message.content,
           "timestamp": message.timestamp,
           // 추가적인 속성들...
       ]
    }


    
    init() {
        chatRoomList.append(ChatRoomStore.chatRoom)
        messageList = ChatRoomStore.chatRoom.messages
    }
    
    static let chatRoom = ChatRoom(
        otherUser: User(),
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


