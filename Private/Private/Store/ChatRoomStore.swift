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
    
    let userCollection = Firestore.firestore().collection("User")
    let docRef = Firestore.firestore().collection("User")
    
    func subscribeToChatRoomChanges (user: User) {
        print("email")
        print(user.email)
        print("count")
        print(chatRoomList.count)
        print("user.nickname")
        print(user.nickname)
        
        var chatRooms: [ChatRoom] = []
        
        let userCollection = Firestore.firestore().collection("ChatRoom")
        
        userCollection
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting chat room documents: \(error)")
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("No chat room documents found for the given nickname")
                    return
                }
                
                for document in querySnapshot.documents {
                    
                    let documentID = document.documentID
                    
                    let nicknames = documentID.split(separator: ",")
                    
                    if let nickname1 = nicknames.first, let nickname2 = nicknames.last {
                        if (nickname1 == user.nickname || nickname2 == user.nickname) {
                            let documentData = document.data()
                            if let chatRoomData = documentData as? [String: Any],
                               let firstUserNickname = chatRoomData["firstUserNickname"] as? String,
                               let firstUserProfileImage = chatRoomData["firstUserProfileImage"] as? String,
                               let secondUserNickname = chatRoomData["secondUserNickname"] as? String,
                               let secondUserProfileImage = chatRoomData["secondUserProfileImage"] as? String {
                                let chatRoom = ChatRoom(firstUserNickname: firstUserNickname, firstUserProfileImage: firstUserProfileImage, secondUserNickname: secondUserNickname, secondUserProfileImage: secondUserProfileImage)
                                chatRooms.append(chatRoom)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self?.chatRoomList = chatRooms
                    }
                }
            }
    }
    
    func addChatRoomToUser(user: User, chatRoom: ChatRoom) {
        let userCollection = Firestore.firestore().collection("ChatRoom")
        if (user.nickname == chatRoom.firstUserNickname) {
            let subCollection = userCollection.document("\(user.nickname),\(chatRoom.secondUserNickname)")
            
            var chatRoomData: [String: Any] = [:]
            
            chatRoomData["firstUserNickname"] = chatRoom.firstUserNickname
            chatRoomData["firstUserProfileImage"] = chatRoom.firstUserProfileImage
            chatRoomData["secondUserNickname"] = chatRoom.secondUserNickname
            chatRoomData["secondUserProfileImage"] = chatRoom.secondUserProfileImage
            
            
            subCollection.setData(chatRoomData) { error in
                if let error = error {
                    print("Error adding chatRoom: \(error.localizedDescription)")
                } else {
                    print("Reservation added to Firestore")
                }
            }
        } else {
            let subCollection = userCollection.document("\(user.nickname),\(chatRoom.firstUserNickname)")
            
            var chatRoomData: [String: Any] = [:]
            
            chatRoomData["firstUserNickname"] = chatRoom.firstUserNickname
            chatRoomData["firstUserProfileImage"] = chatRoom.firstUserProfileImage
            chatRoomData["secondUserNickname"] = chatRoom.secondUserNickname
            chatRoomData["secondUserProfileImage"] = chatRoom.secondUserProfileImage
            
            subCollection.setData(chatRoomData) { error in
                if let error = error {
                    print("Error adding chatRoom: \(error.localizedDescription)")
                } else {
                    print("Reservation added to Firestore")
                }
            }
        }
    }
    
    func fetchMessage(myNickName: String, otherUserNickname: String){
        self.messageList = []
        print("=======fetchMessage=========")
        let userCollection = Firestore.firestore().collection("ChatRoom")
        let subCollection1 = userCollection.document("\(myNickName),\(otherUserNickname)")
        let messageCollection1 = subCollection1.collection("Message")
        
        let subCollection2 = userCollection.document("\(otherUserNickname),\(myNickName)")
        let messageCollection2 = subCollection2.collection("Message")
        
        userCollection
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting chat room documents: \(error)")
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("No chat room documents found for the given nickname")
                    return
                }
                print("=======for=========")
                
                for document in querySnapshot.documents {
                    let documentID = document.documentID
                    if documentID == "\(myNickName),\(otherUserNickname)" {
                        print("documentID: \(myNickName),\(otherUserNickname)")
                        messageCollection1.order(by: "timestamp", descending: false).getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("Error getting chat room documents: \(error)")
                                return
                            }
                            
                            guard let querySnapshot = querySnapshot else {
                                print("No chat room documents found for the given nickname")
                                return
                            }
                            
                            
                            for document in querySnapshot.documents {
                                let documentData = document.data()
                                print("documentData: \(documentData)")
                                if let messageData = documentData as? [String: Any],
                                   let sender = messageData["sender"] as? String,
                                   let content = messageData["content"] as? String,
                                   let timestamp = messageData["timestamp"] as? Double {
                                    let message = Message(sender: sender, content: content, timestamp: timestamp)
                                    print("message: \(message)")
                                    self.messageList.append(message)
                                }
                            }
                        }
                    } else if documentID == "\(otherUserNickname),\(myNickName)" {
                        print("documentID: \(otherUserNickname),\(myNickName)")
                        messageCollection2.order(by: "timestamp", descending: false).getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("Error getting chat room documents: \(error)")
                                return
                            }
                            
                            guard let querySnapshot = querySnapshot else {
                                print("No chat room documents found for the given nickname")
                                return
                            }
                            
                            for document in querySnapshot.documents {
                                //                                for message in messageList
                                let documentData = document.data()
                                if let messageData = documentData as? [String: Any],
                                   let sender = messageData["sender"] as? String,
                                   let content = messageData["content"] as? String,
                                   let timestamp = messageData["timestamp"] as? Double
                                {
                                    let message = Message(sender: sender, content: content, timestamp: timestamp)
                                    self.messageList.append(message)
                                }
                                
                            }
                        }
                    }
                }
            }
    }
    
    func sendMessage(myNickName: String, otherUserNickname: String, message: Message) {
        let userCollection = Firestore.firestore().collection("ChatRoom")
        let subCollection1 = userCollection.document("\(myNickName),\(otherUserNickname)")
        let messageCollection1 = subCollection1.collection("Message")
        
        let subCollection2 = userCollection.document("\(otherUserNickname),\(myNickName)")
        let messageCollection2 = subCollection2.collection("Message")
        
        messageList.append(message)
        
        var messagesData: [String: Any] = [:]
        
        for message in messageList {
            
            if let messageDict = messageToDictionary(message) {
                print("messageDict:\(messageDict)")
                messagesData = messageDict
                
            } else {
                print("Invalid message data")
                return
            }
        }
        userCollection
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting chat room documents: \(error)")
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("No chat room documents found for the given nickname")
                    return
                }
                
                for document in querySnapshot.documents {
                    let documentID = document.documentID
                    if documentID == "\(myNickName),\(otherUserNickname)" {
                        messageCollection1.addDocument(data: messagesData) { error in
                            if let error = error {
                                print("Error adding chatRoom: \(error.localizedDescription)")
                            } else {
                                print("Reservation added to Firestore")
                            }
                        }
                    } else if documentID == "\(otherUserNickname),\(myNickName)" {
                        messageCollection2.addDocument(data: messagesData) { error in
                            if let error = error {
                                print("Error adding chatRoom: \(error.localizedDescription)")
                            } else {
                                print("Reservation added to Firestore")
                            }
                        }
                    }
                }
            }
    }

    // Message 객체를 딕셔너리로 변환하는 함수
    func messageToDictionary(_ message: Message) -> [String: Any]? {
        return [
            "sender": message.sender,
            "content": message.content,
            "timestamp": message.timestamp,
        ]
    }
    
    func fetchChatRoom(sender: User) {
        Firestore.firestore().document("\(sender.email)").getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
            } else if let chatRoomData = snapshot?.data() {
                if let chatroomDictArray = chatRoomData["chattingRoom"] as? [[String: Any]] {
                    for dict in chatroomDictArray {
                        if let chatroom = ChatRoom(document: dict) {
                            self.chatRoomList.append(chatroom)
                        }
                    }
                }
            }
        }
        print("\(chatRoomList)")
    }
    
    init() {
        //        chatRoomList.append(ChatRoomStore.chatRoom)
        //        messageList = ChatRoomStore.chatRoom.messages
    }
    
    //    static let chatRoom = ChatRoom(
    //        otherUserName: "userName", otherUserNickname: "boogie", otherUserProfileImage: "이미지", messages: message
    //    )
    
    //    static let message = [
    //        Message(
    //            sender: "나",
    //            content: "여기 어때?",
    //            timestamp: Date().timeIntervalSince1970
    //        ),
    //        Message(
    //            sender: "상대방",
    //            content: "좀 괜찮던데?",
    //            timestamp: Date().timeIntervalSince1970
    //        ),
    //        Message(
    //            sender: "나",
    //            content: "머먹음?",
    //            timestamp: Date().timeIntervalSince1970
    //        ),
    //        Message(
    //            sender: "상대방",
    //            content: "크림치즈파스타가 진짜 존맛이더라 꼭 먹어라 여기서 만약에 더 길어진다면?!?!?!?!?!!?!? 더 길어지냐??\n 줄바꿈도 되냐?",
    //            timestamp: Date().timeIntervalSince1970
    //        )
    //    ]
}


