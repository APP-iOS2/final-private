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
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    @State private var currentPicture = 0
    @State private var isChatRoomActive: Bool = false
    @State private var isShowingChatSendView: Bool = false
    @State private var messageToSend: String = ""
    
    @State private var message: String = ""
    @State private var isShowingMessageTextField: Bool = false
    
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
                            if colorScheme == ColorScheme.dark {
                                Image(userStore.user.myFeed.contains( feed.images[0]) ? "bookmark_fill" : "bookmark_dark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .padding(.trailing, 5)
                            } else {
                                Image(userStore.user.myFeed.contains( feed.images[0]) ? "bookmark_fill" : "bookmark_light")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .padding(.trailing, 5)
                            }
                        }
                        Button {
                            withAnimation {
                                isShowingMessageTextField.toggle()
                            }
                        } label: {
                            Image(systemName: isShowingMessageTextField ? "paperplane.fill" : "paperplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .font(.pretendardRegular14)
                                .foregroundColor(.white)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 8)
                                .background(isShowingMessageTextField ? Color.privateColor : Color.darkGrayColor)
                                .cornerRadius(30)
                        }
                    }
                    .font(.pretendardMedium24)
                    .foregroundColor(.primary)
                    .padding(.trailing, 10)
                }
                Spacer()
            }
            .padding(.leading, 20)
            
            if isShowingMessageTextField {
                SendMessageTextField(text: $message, placeholder: "메시지를 입력하세요") {
                    let chatRoom = chatRoomStore.findChatRoom(user: userStore.user, firstNickname: userStore.user.nickname, secondNickname: feed.writerNickname) ?? ChatRoom(firstUserNickname: "ii", firstUserProfileImage: "", secondUserNickname: "boogie", secondUserProfileImage: "")
                    chatRoomStore.sendMessage(myNickName: userStore.user.nickname, otherUserNickname: userStore.user.nickname == chatRoom.firstUserNickname ? chatRoom.secondUserNickname : chatRoom.firstUserNickname, message: Message(sender: userStore.user.nickname, content: message, timestamp: Date().timeIntervalSince1970))
                    message = ""
                }
                .padding(.top, 10)
            }
            
            Divider()
                .padding(.vertical, 10)
        }
    }
}

//struct MapFeedCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapFeedCellView()
//    }
//}
