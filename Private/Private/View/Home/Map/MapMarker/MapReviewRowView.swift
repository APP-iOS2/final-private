//
//  MapReviewRowView.swift
//  Private
//
//  Created by yeon I on 2023/09/26.
//

import SwiftUI
struct MapReviewRowView: View {
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    @State private var isChatRoomActive: Bool = false
    @State private var isShowingChatSendView: Bool = false
    @State private var messageToSend: String = ""
    
    var feed: Feed
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(feed.images, id: \.self) { imageName in
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Image(feed.writer.profileImageURL)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)
                                .clipShape(Circle())
                        }
                        VStack {
                            Text(feed.writer.nickname)
                                .font(.pretendardSemiBold14)
                            Text(feed.writer.name)
                                .font(.pretendardSemiBold12)
                        }
                        Spacer()
                    }
                    HStack {
                        VStack{
                            Image(imageName)
                                .resizable()
                                .frame(width: 120, height: 120)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(10)
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text(feed.contents)
                                .font(.pretendardRegular12)
                                .padding(.leading, 10)
                                .lineSpacing(3)
                                .lineLimit(4) // 최대 4줄로 제한
                            //.padding(.bottom, 15)
                            HStack {
                                Spacer()
                                Button {
                                    //isChatRoomActive = true
                                    //채팅룸으로 이동
                                    isShowingChatSendView.toggle()
                                } label: {
                                    Image(systemName: "paperplane")
                                        .font(.pretendardRegular14)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.darkGrayColor)
                                        .cornerRadius(30)
                                }
                                .sheet(isPresented: $isShowingChatSendView) {
                                    ChatSendView(message: $messageToSend, onSend: { sentMessage in
                                        chatRoomStore.messageList.append(Message(sender: "나", content: sentMessage, timestamp: Date().timeIntervalSince1970))
                                    
                                        isShowingChatSendView = false
                                    })
                                }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

//struct MapReviewRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(dummyFeeds, id: \.id) { feed in
//            MapReviewRowView(feed: feed)
//                .environmentObject(ChatRoomStore()) // 미리보기에 ChatRoomStore를 주입
//        }
//    }
//}
