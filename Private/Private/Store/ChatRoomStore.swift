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
    //    var ref = Database.database().reference()
    let docRef = Firestore.firestore().collection("User")
    //    @EnvironmentObject var userStore: UserStore
    
    //
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
                    
                    let nicknames = documentID.split(separator: ",")
                    
                    if let nickname1 = nicknames.first, let nickname2 = nicknames.last {
                        if (nickname1 == user.nickname || nickname2 == user.nickname) {
                            let documentData = document.data()
                            if let chatRoomData = documentData as? [String: Any],
                               //                       let messagesData = chatRoomData["messages"] as? [[String: Any]],
                               let otherUserName = chatRoomData["otherUserName"] as? String,
                               let otherUserNickname = chatRoomData["otherUserNickname"] as? String,
                               let otherUserProfileImage = chatRoomData["otherUserProfileImage"] as? String {
                                let chatRoom = ChatRoom(otherUserName: otherUserName, otherUserNickname: otherUserNickname, otherUserProfileImage: otherUserProfileImage)
                                chatRooms.append(chatRoom)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.chatRoomList = chatRooms
                        print("chatRooms.count::\(chatRooms.count)")
                        print("chatRoomList.count")
                        print(self.chatRoomList.count)
                    }
                }
            }
    }
    
    func addChatRoomToUser(user: User, chatRoom: ChatRoom) {
        //채팅방 만들기
        let userCollection = Firestore.firestore().collection("ChatRoom")
        let subCollection = userCollection.document("\(user.nickname),\(chatRoom.otherUserNickname)")
        
        var chatRoomData: [String: Any] = [:]
        
        chatRoomData["otherUserName"] = chatRoom.otherUserName
        chatRoomData["otherUserNickname"] = chatRoom.otherUserNickname
        chatRoomData["otherUserProfileImage"] = chatRoom.otherUserProfileImage
        
        
        subCollection.setData(chatRoomData) { error in
            if let error = error {
                print("Error adding chatRoom: \(error.localizedDescription)")
            } else {
                print("Reservation added to Firestore")
            }
        }
    }
    
    func fetchMessage(myNickName: String, otherUserNickname: String){
        print("=======fetchMessage=========")
        let userCollection = Firestore.firestore().collection("ChatRoom")
        let subCollection1 = userCollection.document("\(myNickName),\(otherUserNickname)")
        let messageCollection1 = subCollection1.collection("Message")
        
        let subCollection2 = userCollection.document("\(otherUserNickname),\(myNickName)")
        let messageCollection2 = subCollection2.collection("Message")
        
        var messages: [Message] = []
        
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
                        messageCollection1.getDocuments { (querySnapshot, error) in
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
                        messageCollection2.getDocuments { (querySnapshot, error) in
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
                //                messagesData.append(messageDict)
                messagesData = messageDict
                
            } else {
                print("Invalid message data")
                return
            }
        }
        
        //        ?let use?rCollection = Firestore.firestore().collection("ChatRoom")
        
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
        
        //        messageCollection.addDocument(data: messagesData) { error in
        //            if let error = error {
        //                print("Error adding chatRoom: \(error.localizedDescription)")
        //            } else {
        //                print("Reservation added to Firestore")
        //            }
        //        }
    }
    
    //MARK: - 미사용
    
    //    func addChatRoomToUser(user: User, chatRoom: ChatRoom) {
    //        let userCollection = Firestore.firestore().collection("User")
    //        let subCollection = userCollection.document(user.email).collection("chattingRoom")
    //
    //        // ChatRoom 데이터 생성
    //        var chatRoomData: [String: Any] = [:]
    //
    ////        if let otherUserDict = userToDictionary(user: chatRoom.otherUser) {
    ////            chatRoomData["otherUser"] = otherUserDict
    ////        } else {
    ////            print("Invalid other user data")
    ////            return
    ////        }
    //
    //        var messagesData: [[String: Any]] = []
    //
    //        for message in chatRoom.messages {
    //            if let messageDict = messageToDictionary(message) {
    //                print("messageDict:\(messageDict)")
    //                messagesData.append(messageDict)
    //            } else {
    //                print("Invalid message data")
    //                return
    //            }
    //        }
    //
    //        chatRoomData["messages"] = messagesData
    //
    //        subCollection.document(chatRoom.otherUserNickname).setData(chatRoomData)
    //        // chattingRooms 컬렉션에 채팅방 데이터 추가
    ////        subCollection.addDocument(data: ["chattingRoom": [chatRoomData]]) { error in
    ////            if let error = error {
    ////                print("Error adding chat room to user: \(error.localizedDescription)")
    ////            } else {
    ////                print("chatRoomData::\(chatRoomData)")
    ////                print("Chat room added to user successfully")
    ////            }
    ////        }
    //    }
    
    
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


