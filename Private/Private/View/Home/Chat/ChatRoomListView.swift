//
//  ChatRoomListView.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI

struct ChatRoomListView: View {
    
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var searchText: String = ""
    
    // 사용자 정보 생성
//    let user = User(email: "example@example.com", name: "John Doe")

    // 채팅방 정보 생성
//    let otherUser = User(email: "other@example.com", name: "Jane Smith")
    let otherUser = User()

    let message1 = Message(sender: "nickname1", content: "Hello!", timestamp: Date().timeIntervalSince1970)
    let message2 = Message(sender:  "nickname2", content: "Hi!", timestamp: Date().timeIntervalSince1970 + 1)
    var chatRoom = ChatRoom(otherUserName: "이수민", otherUserNickname: "ii", otherUserProfileImage: "")
    // addChatRoomToUser 메서드 호출하여 채팅방 추가
//    addChatRoomToUser(user: user, chatRoom: chatRoom)
    
    var body: some View {
        List {
            SearchBarTextField(text: $searchText, placeholder: "검색")
                .padding(.top, 10)
                .listRowSeparator(.hidden)
            
            ForEach(chatRoomStore.chatRoomList, id: \.self) { chatRoom in
                ZStack { // List에서 오른쪽 화살표 제거하기 위해 ZStack으로 덮어버림
                    NavigationLink {
                        ChatRoomView(chatRoom: chatRoom)
                    } label: {
                        ChatRoomCellView(chatRoom: chatRoom)
                    }
                    .opacity(0)
                    ChatRoomCellView(chatRoom: chatRoom)
                }
            }
            .onDelete(perform: deleteChatRoom)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        
        .refreshable {
            
        }
        .onAppear{
            chatRoomStore.subscribeToChatRoomChanges(user: userStore.user)
//            chatRoomStore.messageList = [message1]
//            chatRoom = ChatRoom(otherUserName: "s", otherUserNickname: "boogie", otherUserProfileImage: "", messages: [message1,message2])
        }
        .navigationTitle("채팅방")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EditButton().foregroundColor(.accentColor))
        .navigationBarItems(trailing:
                                Button{print(":::chatRoom")
//                                print("\(chatRoom)")
                                // 테스트를 위한 더미데이터
//                                let chatRoom = ChatRoom(otherUser: otherUser, messages: [Message(sender: "nickname1", content: "Hello!", timestamp: Date().timeIntervalSince1970)])
                                chatRoomStore.addChatRoomToUser(user: userStore.user, chatRoom: chatRoom)
            chatRoomStore.subscribeToChatRoomChanges(user: userStore.user)
        } label: {
                                Image(systemName: "plus.bubble")
        }
                            )
                            
    }
    
    func deleteChatRoom(at offsets: IndexSet) {
        chatRoomStore.chatRoomList.remove(atOffsets: offsets)
    }
}

struct ChatRoomListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatRoomListView()
                .environmentObject(ChatRoomStore())
        }
    }
}
