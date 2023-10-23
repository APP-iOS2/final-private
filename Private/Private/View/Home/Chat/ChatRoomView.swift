//
//  ChatRoomView.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI
import Kingfisher

struct ChatRoomView: View {
    
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var message: String = ""
    
    var chatRoom: ChatRoom
    
    var body: some View {
            ZStack{
                VStack{
                    List(chatRoomStore.messageList, id: \.self) { message in
                        if (message.sender == userStore.user.nickname) {
                            HStack(alignment: .bottom){
                                Spacer()
                                Text(formatTimestamp(message.timestamp))
                                    .font(.pretendardRegular12)
                                Text(message.content)
                                    .padding(10)
                                    .padding(.horizontal, 5)
                                    .background(Color.privateColor)
                                    .foregroundColor(.black)
                                    .cornerRadius(20)
                                    .frame(alignment: .trailing)
                                
                            }
                            .listRowSeparator(.hidden)
                        } else {
                            HStack(alignment: .bottom){
                                Text(message.content)
                                    .padding(10)
                                    .padding(.horizontal, 5)
                                    .background(Color.lightGrayColor)
                                    .foregroundColor(Color.chatTextColor)
                                    .cornerRadius(20)
                                    .frame(alignment: .leading)
                                Text(formatTimestamp(message.timestamp))
                                    .font(.pretendardRegular12)
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    
                    .listStyle(.plain)
                }
                //    }
                if chatRoomStore.isShowingChatLoading {
                    ProgressView()
                }
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if (userStore.user.nickname == chatRoom.firstUserNickname) {
                        HStack {
                            KFImage(URL(string: chatRoom.secondUserProfileImage))
                                .placeholder {
                                    Image("userDefault")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                        .cornerRadius(50)
                                }
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .cornerRadius(50)
                            VStack(alignment: .leading) {
                                Text("\(chatRoom.secondUserNickname)")
                                    .font(.pretendardSemiBold14)
                            }
                            .padding(.leading, 5)
                            Spacer()
                            
                        }
                    } else {
                        HStack {
                            Image("userDefault")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .cornerRadius(50)
                            VStack(alignment: .leading) {
                                Text("\(chatRoom.firstUserNickname)")
                                    .font(.pretendardSemiBold14)
                            }
                            .padding(.leading, 5)
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .backButtonArrow()
            
            .onAppear {
                chatRoomStore.removeListener()
                chatRoomStore.fetchMessage(myNickName: userStore.user.nickname, otherUserNickname: userStore.user.nickname == chatRoom.firstUserNickname ? chatRoom.secondUserNickname : chatRoom.firstUserNickname)
                print("\(chatRoomStore.messageList)")
                print("\(userStore.user)")
                print("\(chatRoom)")
            }
            .onDisappear {
                chatRoomStore.subscribeToChatRoomChanges(user: userStore.user)
                chatRoomStore.stopFetchMessage()
            }
            SendMessageTextField(text: $message, placeholder: "메시지를 입력하세요") {
                print("chatRoom-sendMessage\(chatRoom)")
                if message != "" {
                    chatRoomStore.sendMessage(myNickName: userStore.user.nickname, otherUserNickname: userStore.user.nickname == chatRoom.firstUserNickname ? chatRoom.secondUserNickname : chatRoom.firstUserNickname, message: Message(sender: userStore.user.nickname, content: message, timestamp: Date().timeIntervalSince1970))
                    message = ""
                }
            }
    }
    
    func formatTimestamp(_ timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp) // 타임스탬프로부터 날짜 생성
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 원하는 시간 형식 설정
        
        return formatter.string(from: date) // 포맷팅된 시간 반환
    }
}

//struct ChatRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomView(chatRoom: ChatRoomStore.chatRoom)
//    }
//}
