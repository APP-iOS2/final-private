//
//  ChatRoomCellView.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI
import Kingfisher


struct ChatRoomCellView: View {
    
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    var chatRoom: ChatRoom
    
    var body: some View {
        if (userStore.user.nickname == chatRoom.firstUserNickname) {
            HStack {
                KFImage(URL(string: chatRoom.secondUserProfileImage))
                    .placeholder {
                        Image("userDefault")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: .screenWidth*0.13, height: .screenWidth*0.13)
                    }
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: .screenWidth*0.13, height: .screenWidth*0.13)
                VStack(alignment: .leading) {
                    Text("\(chatRoom.secondUserNickname)")
                        .font(.pretendardSemiBold16)
                }
                .padding(.leading, 5)
                Spacer()
            }
        } else {
            HStack {
                KFImage(URL(string: chatRoom.firstUserProfileImage))
                    .placeholder {
                        Image("userDefault")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: .screenWidth*0.13, height: .screenWidth*0.13)
                    }
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: .screenWidth*0.13, height: .screenWidth*0.13)
                
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
