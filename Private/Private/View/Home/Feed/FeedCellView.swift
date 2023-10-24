//
//  FeedCellView.swift
//  Private
//
//  Created by yeon on 10/10/23.
import FirebaseFirestore
import SwiftUI
import NMapsMap
import Kingfisher
import FirebaseStorage
import ExpandableText

struct FeedCellView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var feed: MyFeed
    @State private var currentPicture = 0
    @EnvironmentObject var userDataStore: UserStore
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject var chatRoomStore: ChatRoomStore
    
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    @ObservedObject var detailCoordinator = DetailCoordinator.shared

    @State private var message: String = ""
    @State private var isShowingMessageTextField: Bool = false
    @State private var isFeedUpdateViewPresented: Bool = false
    @State private var isActionSheetPresented = false // 액션 시트 표시 여부를 관리하는 상태 변수
    @State private var isShowingLocation: Bool = false
    @State private var isChangePlaceColor: Bool = false
    @State private var isExpanded: Bool = false //글 더보기
    @State private var isTruncated: Bool = false//글 더보기
    @State private var lat: String = ""
    @State private var lng: String = ""
    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    @Binding var root: Bool
    @Binding var selection: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
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
                        .padding(.trailing, 5)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(feed.writerNickname)")
                            .font(.pretendardMedium16)
                        Text("\(feed.createdDate)")
                            .font(.pretendardRegular12)
                            .foregroundColor(.primary.opacity(0.8))
                    }
                    Spacer()
                    //MARK:  조건부로 FeedUpdateView 표시
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
                            }
                            .actionSheet(isPresented: $isActionSheetPresented) {
                                ActionSheet(
                                    title: Text("선택하세요"),
                                    buttons: [
                                        .default(Text("수정")) {
                                            print("수정")
                                            //MARK: FeedCellView에서 수정하는 곳
                                            print("File: \(#file), Line: \(#line), Function: \(#function), Column: \(#column)","\(feed.id)")
                                            isFeedUpdateViewPresented = true
                                        },
                                        .destructive(Text("삭제")) {
                                            print("삭제")
                                            userStore.deleteMyFeed(feed)
                                            feedStore.deleteFeed(feedId: feed.id)
                                            userStore.updateUser(user: userStore.user)
                                            feedStore.deleteToast = true
                                        },
                                        //.cancel() // 취소 버튼
                                        .cancel(Text("취소"))
                                    ]
                                )
                            }
                            .fullScreenCover(isPresented: $isFeedUpdateViewPresented) {
                                FeedUpdateView(root:$root, selection: $selection, isFeedUpdateViewPresented: $isFeedUpdateViewPresented, searchResult: $searchResult, feed:feed)
                            }
                        }
                    }
                }
                //MARK:  사진과 닉네임 사이 간격 조정 20->10
                .padding(.leading, 20)
                .padding(.bottom, 5)
                
                TabView(selection: $currentPicture) {
                    ForEach(feed.images, id: \.self) { image in
                        KFImage(URL(string: image ))
                            .placeholder {
                                Image(systemName: "photo")
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: .screenWidth, height: .screenWidth)
                            .clipped()
                            .padding(.bottom, 10)
                            .tag(Int(feed.images.firstIndex(of: image) ?? 0))
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(width: .screenWidth, height: .screenWidth)
            }
            .padding(.bottom, 10)
            
            //MARK: 회색 장소 박스
            HStack {
                HStack {
                    Button {
                        if (userStore.user.bookmark.contains("\(feed.id)")) {
                            userStore.deletePlace(feed)
                            userStore.user.bookmark.removeAll { $0 == "\(feed.id)" }
                            userStore.updateUser(user: userStore.user)
                            userStore.clickSavedCancelPlaceToast = true
                            isChangePlaceColor.toggle()
                        } else {
                            userStore.savePlace(feed) //장소 저장 로직(사용가능)
                            userStore.user.bookmark.append("\(feed.id)")
                            userStore.updateUser(user: userStore.user)
                            userStore.clickSavedPlaceToast = true
                            isChangePlaceColor.toggle()
                        }
                    } label: {
                        Image(systemName: userStore.user.bookmark.contains("\(feed.id)") ? "pin.fill": "pin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .padding(.horizontal, 10)
                            .foregroundColor(isChangePlaceColor ? .privateColor : .white)
                            .foregroundColor(userStore.user.bookmark.contains("\(feed.images[0].suffix(32))") ? .privateColor : .primary)
                    }
                    .padding(.leading, 5)
                    //MARK: 회색 박스 안 주소와 가게명
                    Button {
                        isShowingLocation = true
                        
                        lat = locationSearchStore.formatCoordinates(feed.mapy, 2) ?? ""
                        lng = locationSearchStore.formatCoordinates(feed.mapx, 3) ?? ""
                        
                        detailCoordinator.coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
                        postCoordinator.newMarkerTitle = feed.title
                        searchResult.title = feed.title
                        
                        print("피드 장소 선택 시 좌표: \(postCoordinator.coord)")
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(feed.title)")
                                .font(.pretendardMedium16)
                                .foregroundColor(.primary)
                            Text("\(feed.roadAddress)")
                                .font(.pretendardRegular12)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.leading, 10)
                    }
                }
                .padding(.horizontal, 10)
                //            .frame(width: .screenWidth * 0.7, height: 80)
                //            .background(Color.darkGraySubColor)
                
                .sheet(isPresented: $isShowingLocation) {
                    LocationDetailView(searchResult: $searchResult)
                        .presentationDetents([.height(.screenHeight * 0.6), .large])
                }
                
                Spacer()
                
                HStack {
                    if feed.writerNickname != userStore.user.nickname {
                        Divider()
                        
                        Button {
                            if(userStore.user.myFeed.contains("\(feed.id)")) {
                                userStore.deleteSavedFeed(feed)
                                userStore.user.myFeed.removeAll { $0 == "\(feed.id)" }
                                userStore.updateUser(user: userStore.user)
                                userStore.clickSavedCancelFeedToast = true
                            } else {
                                userStore.saveFeed(feed) //장소 저장 로직(사용가능)
                                userStore.user.myFeed.append("\(feed.id)")
                                userStore.updateUser(user: userStore.user)
                                userStore.clickSavedFeedToast = true
                            }
                        } label: {
                            if colorScheme == ColorScheme.dark {
                                Image(userStore.user.myFeed.contains("\(feed.id)") ? "bookmark_fill" : "bookmark_dark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .padding(.trailing, 5)
                            } else {
                                Image(userStore.user.myFeed.contains( "\(feed.id)" ) ? "bookmark_fill" : "bookmark_light")
                                    .resizable()
                                    .scaledToFit()
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
                                .foregroundColor(isShowingMessageTextField ? .privateColor : .white)
                        }
                    }
                }
                .font(.pretendardMedium24)
                .foregroundColor(.primary)
                .padding(.trailing)
            }
            .padding(.vertical, 20)
            .background(Color.darkGraySubColor)
            
            VStack(alignment: .center) {
                //MARK: 회색 박스 안 주소와 가게명 끝
                if isShowingMessageTextField {
                    SendMessageTextField(text: $message, placeholder: "메시지를 입력하세요") {
                        let chatRoom = chatRoomStore.findChatRoom(user: userStore.user, firstNickname: userStore.user.nickname,firstUserProfileImage:userStore.user.profileImageURL, secondNickname: feed.writerNickname,secondUserProfileImage:feed.writerProfileImage) ?? ChatRoom(firstUserNickname: "ii", firstUserProfileImage: "", secondUserNickname: "boogie", secondUserProfileImage: "")
                        chatRoomStore.sendMessage(myNickName: userStore.user.nickname, otherUserNickname: userStore.user.nickname == chatRoom.firstUserNickname ? chatRoom.secondUserNickname : chatRoom.firstUserNickname, message: Message(sender: userStore.user.nickname, content: message, timestamp: Date().timeIntervalSince1970))
                        message = ""
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            VStack(alignment: .leading) {
                Text("\(feed.contents)")
                    .font(.pretendardRegular16)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
            }
            
            //        VStack(alignment: .leading) {
            //            ExpandableText(text: feed.contents)
            //                .font(.pretendardRegular16)
            //                .lineLimit(3)
            //                .expandAnimation(.easeOut)
            //                .expandButton(TextSet(text: "더보기", font: .pretendardRegular16, color: .privateColor))
            //                .collapseButton(TextSet(text: "접기", font: .pretendardRegular16, color: .privateColor))
            //        }
            //        .padding(.horizontal, 10)
            
            Divider()
                .padding(.vertical, 10)
        }
    }
}
