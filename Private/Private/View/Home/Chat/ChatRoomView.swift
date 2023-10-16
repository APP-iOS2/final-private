//
//  ChatRoomView.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI

struct ChatRoomView: View {
    
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    @State private var message: String = ""
    
    var chatRoom: ChatRoom
    
    var body: some View {
        List(chatRoomStore.messageList, id: \.self) { message in
            if (message.sender == "나") {
                Text(message.content)
                    .padding(10)
                    .padding(.horizontal, 5)
                    .background(Color.accentColor)
                    .foregroundColor(.black)
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .listRowSeparator(.hidden)
            } else {
                Text(message.content)
                    .padding(10)
                    .padding(.horizontal, 5)
                    .background(Color.lightGrayColor)
                    .foregroundColor(.chatTextColor)
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image("userDefault")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .cornerRadius(50)
                    VStack(alignment: .leading) {
                        Text("\(chatRoom.otherUserName)")
                            .font(.pretendardSemiBold14)
                        Text("\(chatRoom.otherUserNickname)")
                            .font(.pretendardRegular12)
                    }
                    .padding(.leading, 5)
                    Spacer()
                }
            }
        }
        
        SendMessageTextField(text: $message, placeholder: "메시지를 입력하세요") {
            sendMessage()
        }
    }
    
    func sendMessage() {
        chatRoomStore.messageList.append(Message(sender: "나", content: message, timestamp: Date().timeIntervalSince1970))
    }
}

//struct ChatRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomView(chatRoom: ChatRoomStore.chatRoom)
//    }
//}
