//
//  ChatRoomCellView.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI

struct ChatRoomCellView: View {
    
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    var chatRoom: ChatRoom
    
    var body: some View {
        if (userStore.user.nickname == chatRoom.firstUserNickname) {
            HStack {
                Image("userDefault")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .cornerRadius(50)
                VStack(alignment: .leading) {
                    Text("\(chatRoom.secondUserNickname)")
                        .font(.pretendardSemiBold16)
                }
                .padding(.leading, 5)
                Spacer()
            }
        } else {
            HStack {
                Image("userDefault")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .cornerRadius(50)
                VStack(alignment: .leading) {
                    Text("\(chatRoom.firstUserNickname)")
                        .font(.pretendardSemiBold16)
                }
                .padding(.leading, 5)
                Spacer()
            }
        }
    }
}

//struct ChatRoomCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomCellView(chatRoom: ChatRoom())
//            .environmentObject(ChatRoomStore())
//    }
//}
