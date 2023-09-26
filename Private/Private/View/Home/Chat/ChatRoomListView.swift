//
//  ChatRoomListView.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI

struct ChatRoomListView: View {
    
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    @State private var searchText: String = ""
    
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
        .navigationTitle("채팅방")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EditButton().foregroundColor(.accentColor))
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
