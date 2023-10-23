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
    @State private var inSearchMode = false
    
    var body: some View {
        List {
            SearchBarTextField(text: $searchText, isEditing: $inSearchMode, placeholder: "검색")
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
        .navigationBarBackButtonHidden(true)
        .backButtonArrow()
        .navigationBarItems(trailing: EditButton().foregroundColor(.privateColor))
    }
    
//    func deleteChatRoom(at offsets: IndexSet) {
//        chatRoomStore.chatRoomList.remove(atOffsets: offsets)
//        chatRoomStore.removeChatRoom(myNickName: userStore.user.nickname, otherUserNickname: chatRoomStore.chatRoomList[offsets])
//    }
//    
    func deleteChatRoom(at offsets: IndexSet) {
        let selectedIndices = Array(offsets)
        for index in selectedIndices {
            let chatRoom = chatRoomStore.chatRoomList[index]
            let otherUserNickname: String
            if userStore.user.nickname == chatRoom.firstUserNickname {
                otherUserNickname = chatRoom.secondUserNickname
            } else {
                otherUserNickname = chatRoom.firstUserNickname
            }
            
            // Chat Room 삭제 로직 추가
            chatRoomStore.removeChatRoom(myNickName: userStore.user.nickname, otherUserNickname: otherUserNickname)
        }
        
        // 선택된 Chat Room 삭제
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
