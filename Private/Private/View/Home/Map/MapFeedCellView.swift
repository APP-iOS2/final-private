//
//  MapFeedCellView.swift
//  Private
//
//  Created by 변상우 on 10/18/23.
//

import SwiftUI
import NMapsMap
import Kingfisher

struct MapFeedCellView: View {
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    @State private var currentPicture = 0
    @State private var isChatRoomActive: Bool = false
    @State private var isShowingChatSendView: Bool = false
    @State private var messageToSend: String = ""
    
    var feed: MyFeed
    
    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: feed.writerProfileImage))
                    .resizable()
                    .placeholder {
                        Image("userDefault")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: .screenWidth*0.13, height: .screenWidth*0.13)
                    }
                    .clipShape(Circle())
                    .frame(width: .screenWidth*0.13, height: .screenWidth*0.13)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(feed.writerNickname)")
                        .font(.pretendardMedium16)
                    Text("\(feed.createdDate)")
                        .font(.pretendardRegular12)
                        .foregroundColor(.primary.opacity(0.8))
                }
                Spacer()
            }
            .padding(.top, 15)
            .padding(.leading, 20)
            .padding(.bottom, 10)
            
            HStack(alignment: .top) {
                TabView(selection: $currentPicture) {
                    ForEach(feed.images, id: \.self) { image in
                        KFImage(URL(string: image )) .placeholder {
                            Image(systemName: "photo")
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: .screenWidth * 0.45, height: .screenWidth * 0.45)
                        .tag(Int(feed.images.firstIndex(of: image) ?? 0))
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(width: .screenWidth * 0.45, height: .screenWidth * 0.45)
                .padding(.trailing, 15)
                
                VStack(alignment: .leading) {
                    Text("\(feed.contents)")
                        .font(.pretendardRegular16)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button {
                            if(userStore.user.myFeed.contains(feed.images[0])) {
                                for userStoreImageId in userStore.user.myFeed {
                                    for myFeed in userStore.mySavedFeedList {
                                        if userStoreImageId == myFeed.images[0] {
                                            userStore.deleteFeed(myFeed)
                                        }
                                    }
                                }
                                userStore.user.myFeed.removeAll { $0 == feed.images[0] }
                                userStore.updateUser(user: userStore.user)
                            } else {
                                userStore.saveFeed(feed) //장소 저장 로직(사용가능)
                                userStore.user.myFeed.append(feed.images[0])
                                userStore.updateUser(user: userStore.user)
                            }
                        } label: {
                            Image( systemName: userStore.user.myFeed.contains( feed.images[0]) ? "bookmark.fill" : "bookmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: .screenWidth*0.035)
                        }
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
                    .font(.pretendardMedium24)
                    .foregroundColor(.primary)
                    .padding(.trailing, 10)
                }
                Spacer()
            }
            .padding(.leading, 20)
        }
    }
}

//struct MapFeedCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapFeedCellView()
//    }
//}
