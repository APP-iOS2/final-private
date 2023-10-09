//
//  ChatRoomCellView.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI

struct ChatRoomCellView: View {
    
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    var chatRoom: ChatRoom
    
    var body: some View {
        HStack {
            Image("userDefault")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .cornerRadius(50)
            VStack(alignment: .leading) {
                Text("\(chatRoom.otherUser.name)")
                    .font(.pretendardSemiBold16)
                Text("\(chatRoom.otherUser.nickname)")
                    .font(.pretendardRegular12)
            }
            .padding(.leading, 5)
            Spacer()
        }
    }
}

//struct ChatRoomCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomCellView(chatRoom: chatRoom)
//            .environmentObject(ChatRoomStore())
//    }
//}
