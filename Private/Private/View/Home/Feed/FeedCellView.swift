//
//  FeedCellView.swift
//  Private
//
//  Created by yeon on 10/10/23.
//
import SwiftUI
import NMapsMap
import Kingfisher
//import Combine
struct FeedCellView: View {
    
    var feed: MyFeed
    @State private var currentPicture = 0
    @EnvironmentObject private var userStore: UserStore // 피드,장소 저장하는 함수 사용하기 위해서 선언
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    @State private var message: String = ""
    @State private var isShowingMessageTextField: Bool = false
    @State private var isActionSheetPresented = false // 액션 시트 표시 여부를 관리하는 상태 변수
    
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
                
                HStack {
                    if feed.writerNickname == userStore.user.nickname {
                        Button(action: {
                            // 수정 및 삭제 옵션을 표시하는 액션 시트 표시
                            isActionSheetPresented.toggle()
                        }) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                                .foregroundColor(.primary)
                                .padding(.top, 5)
                                .padding(.leading, 15)
                                .padding(.trailing, 15)
                        }
                        .actionSheet(isPresented: $isActionSheetPresented) {
                            ActionSheet(
                                title: Text("선택하세요"),
                                buttons: [
                                    .default(Text("수정")) {
                                        print("수정")
                                    },
                                    .destructive(Text("삭제")) {
                                        print("삭제")
                                        feedStore.deleteFeed(writerNickname: feed.writerNickname)
                                    },
                                    .cancel() // 취소 버튼
                                ]
                            )
                        }
                    }
                }
                
                
            }
            .padding(.leading, 20)
            
            TabView(selection: $currentPicture) {
                ForEach(feed.images, id: \.self) { image in
                    KFImage(URL(string: image )) .placeholder {
                        Image(systemName: "photo")
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)  // 너비와 높이를 화면 너비의 90%로 설정
                    .clipped()
                    .padding(.bottom, 10)  // 아래쪽에 10포인트의 패딩 추가
                    .padding([.leading, .trailing], 15)  // 좌우에 15포인트의 패딩 추가
                    .tag(Int(feed.images.firstIndex(of: image) ?? 0))
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(width: .screenWidth, height: .screenWidth)
        }
        
        HStack(alignment: .top) {
            HStack(alignment: .top) {
                Text("\(feed.contents)")
                    .font(.pretendardRegular16)
                    .foregroundColor(.primary)
                
            }
            .padding(.leading, .screenWidth/2 - .screenWidth*0.45 )
            
            Spacer()
            VStack {
                HStack{
                    Button {
                        if(userStore.user.myFeed.contains(feed.images[0])) {
                            userStore.deleteFeed(feed)
                            userStore.user.myFeed.removeAll { $0 == feed.images[0] }
                            userStore.updateUser(user: userStore.user)
                        } else {
                            userStore.saveFeed(feed) //장소 저장 로직(사용가능)
                            userStore.user.myFeed.append(feed.images[0])
                            userStore.updateUser(user: userStore.user)
                        }
                    } label: {
                        Image(userStore.user.myFeed.contains( feed.images[0]) ? "bookmark_fill" : "bookmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .padding(.trailing, 5)
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
            }
            .font(.pretendardMedium24)
            .foregroundColor(.primary)
            .padding(.trailing,.screenWidth/2 - .screenWidth*0.45)
            //.disabled(true)
        }
        .padding(.top, -25)
        .padding(.bottom, 0)
        
        if isShowingMessageTextField {
            SendMessageTextField(text: $message, placeholder: "메시지를 입력하세요") {
                let chatRoom = chatRoomStore.findChatRoom(user: userStore.user, firstNickname: userStore.user.nickname, secondNickname: feed.writerNickname) ?? ChatRoom(firstUserNickname: "ii", firstUserProfileImage: "", secondUserNickname: "boogie", secondUserProfileImage: "")
                chatRoomStore.sendMessage(myNickName: userStore.user.nickname, otherUserNickname: userStore.user.nickname == chatRoom.firstUserNickname ? chatRoom.secondUserNickname : chatRoom.firstUserNickname, message: Message(sender: userStore.user.nickname, content: message, timestamp: Date().timeIntervalSince1970))
                message = ""
            }
        }
        
        HStack {
            Button {
                if (userStore.user.bookmark.contains("\(feed.images[0].suffix(32))")) {
                    userStore.deletePlace(feed)
                    userStore.user.bookmark.removeAll { $0 == "\(feed.images[0].suffix(32))" }
                    userStore.updateUser(user: userStore.user)
                } else {
                    userStore.savePlace(feed) //장소 저장 로직(사용가능)
                    userStore.user.bookmark.append("\(feed.images[0].suffix(32))")
                    userStore.updateUser(user: userStore.user)
                }
            } label: {
                Image(systemName: userStore.user.bookmark.contains("\(feed.images[0].suffix(32))") ? "pin.fill": "pin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .foregroundColor(.primary)
                    .foregroundColor(userStore.user.bookmark.contains("\(feed.images[0].suffix(32))") ? .privateColor : .primary)
                    .padding(.top, 5)
            }
            .padding(.leading, 15)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(feed.title)")
                    .font(.pretendardMedium16)
                    .foregroundColor(.primary)
                Text("\(feed.roadAddress)")
                    .font(.pretendardRegular12)
                    .foregroundColor(.primary)
            }
            .padding(.leading, 15)
            Spacer()
        }
        .padding(.top, 5)
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
        .background(Color.darkGraySubColor)
        
        Divider()
            .padding(.vertical, 10)
    }
    //.padding(.top, 20)
}
//https://firebasestorage.googleapis.com:443/v0/b/private-43c86.appspot.com/o/81789D33-A401-4701-AB9F-ABBBE6DEC156?alt=media&token=a9b1fcdc-c1f9-48ec-87af-d7b617376365
// https://firebasestorage.googleapis.com:443/v0/b/private-43c86.appspot.com/o/39968E65-7EB6-4D5D-AC00-8C8578AABFFF?alt=media&token=149585b7-ad7a-445a-a770-2e13af631ba0
