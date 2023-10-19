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
    
//    var chatRoom = ChatRoom(firstUserNickname: "boogie", firstUserProfileImage: "", secondUserNickname: "ii", secondUserProfileImage: "")
    
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
            print("chatRoomStore.chatRoomList(ChatRoomListView)::\(chatRoomStore.chatRoomList)")
//            print(chatRoomStore.chatRoomList)
            //최상위  뷰로 호출 전환
//            chatRoomStore.subscribeToChatRoomChanges(user: userStore.user)
//            chatRoomStore.messageList = [message1]
//            chatRoom = ChatRoom(otherUserName: "s", otherUserNickname: "boogie", otherUserProfileImage: "", messages: [message1,message2])
        }
        .navigationTitle("채팅방")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EditButton().foregroundColor(.accentColor))
//        .navigationBarItems(trailing:
//                                Button{print(":::chatRoom")
//                                print("\(chatRoom)")
                                // 테스트를 위한 더미데이터
//                                let chatRoom = ChatRoom(otherUser: otherUser, messages: [Message(sender: "nickname1", content: "Hello!", timestamp: Date().timeIntervalSince1970)])
            //채팅방 추가
//                                chatRoomStore.addChatRoomToUser(user: userStore.user, chatRoom: chatRoom)
//        } label: {
//                                Image(systemName: "plus.bubble")
//        }
                            
                            
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
