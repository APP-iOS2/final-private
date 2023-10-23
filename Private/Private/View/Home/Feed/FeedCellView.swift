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
//import Combine
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
    
    @State private var message: String = ""
    @State private var isShowingMessageTextField: Bool = false
    @State private var isFeedUpdateViewPresented: Bool = false
    @State private var isActionSheetPresented = false // 액션 시트 표시 여부를 관리하는 상태 변수
    @State private var isShowingLocation: Bool = false
    @State private var isExpanded: Bool = false //글 더보기
    @State private var isTruncated: Bool = false//글 더보기
    @State private var lat: String = ""
    @State private var lng: String = ""
    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    @Binding var root: Bool
    @Binding var selection: Int
    
    var body: some View {
        
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
                //.padding(.leading, 50)
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
                                .padding(.leading, 15)
                                .padding(.trailing, 25)
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
                                        feedStore.deleteFeed(feedId: feed.id)
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
            
            TabView(selection: $currentPicture) {
                ForEach(feed.images, id: \.self) { image in
                    KFImage(URL(string: image )) .placeholder {
                        Image(systemName: "photo")
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.95)
                    .clipped()
                    .padding(.bottom, 10)
                    .tag(Int(feed.images.firstIndex(of: image) ?? 0))
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(width: .screenWidth, height: .screenWidth)
        }
        // .padding(.horizontal, )
        
        //MARK: 회색 장소 박스
        HStack {
            HStack {
                Button {
                    if (userStore.user.bookmark.contains("\(feed.id)")) {
                        userStore.deletePlace(feed)
                        userStore.user.bookmark.removeAll { $0 == "\(feed.id)" }
                        userStore.updateUser(user: userStore.user)
                        userStore.clickSavedCancelPlaceToast = true
                    } else {
                        userStore.savePlace(feed) //장소 저장 로직(사용가능)
                        userStore.user.bookmark.append("\(feed.id)")
                        userStore.updateUser(user: userStore.user)
                        userStore.clickSavedPlaceToast = true
                    }
                } label: {
                    Image(systemName: userStore.user.bookmark.contains("\(feed.id)") ? "pin.fill": "pin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.primary)
                        .foregroundColor(userStore.user.bookmark.contains("\(feed.images[0].suffix(32))") ? .privateColor : .primary)
                        .padding(.top, 5)
                }
                .padding(.leading, 15)
                //MARK: 회색 박스 안 주소와 가게명
                Button {
                    isShowingLocation = true
                    
                    lat = locationSearchStore.formatCoordinates(feed.mapy, 2) ?? ""
                    lng = locationSearchStore.formatCoordinates(feed.mapx, 3) ?? ""
                    
                    postCoordinator.coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
                    postCoordinator.newMarkerTitle = feed.title
                    searchResult.title = feed.title
                    
                    postCoordinator.moveCameraPosition()
                    postCoordinator.makeSearchLocationMarker()
                    
                } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(feed.title)")
                            .font(.pretendardMedium16)
                            .foregroundColor(.primary)
                        Text("\(feed.roadAddress)")
                            .font(.pretendardRegular12)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 15)
                }
                Spacer()
            }
            .padding(.top, 5)
            .padding(.horizontal, 10)
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 80)
            .background(Color.darkGraySubColor)
            .sheet(isPresented: $isShowingLocation) {
                LocationDetailView(searchResult: $searchResult)
                    .presentationDetents([.height(.screenHeight * 0.6), .large])
                
                
            }
            VStack {
                HStack {
                    //MARK: 내 글일땐 북마크 안 뜨게 하기
                    if feed.writerNickname != userStore.user.nickname {
                        Button {
                            if(userStore.user.myFeed.contains("\(feed.id)")) {
                                userStore.deleteFeed(feed)
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
                    }
                    //MARK: 내 글일땐 비행기 안 뜨게 하기
                    if feed.writerNickname != userStore.user.nickname {
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
                                .foregroundColor(isShowingMessageTextField ? .white : .primary)  // 조건에 따라 아이콘 색 변경
                                .padding(.horizontal, 25)
                                .padding(.vertical, 8)
                                .background(isShowingMessageTextField ? Color.privateColor : Color.clear) // 조건에 따라 배경색 변경
                                .cornerRadius(30)
                        }
                    }
                }
                .padding(.top, 10) // 비행기와 북마크 위에서 띄우는 간격
            }
            .font(.pretendardMedium24)
            .foregroundColor(.primary)
            .padding(.trailing,.screenWidth/2 - .screenWidth*0.45)
            
        }//MARK: 회색 박스 안 주소와 가게명 끝
        if isShowingMessageTextField {
            SendMessageTextField(text: $message, placeholder: "메시지를 입력하세요") {
                let chatRoom = chatRoomStore.findChatRoom(user: userStore.user, firstNickname: userStore.user.nickname,firstUserProfileImage:userStore.user.profileImageURL, secondNickname: feed.writerNickname,secondUserProfileImage:feed.writerProfileImage) ?? ChatRoom(firstUserNickname: "ii", firstUserProfileImage: "", secondUserNickname: "boogie", secondUserProfileImage: "")
                                chatRoomStore.sendMessage(myNickName: userStore.user.nickname, otherUserNickname: userStore.user.nickname == chatRoom.firstUserNickname ? chatRoom.secondUserNickname : chatRoom.firstUserNickname, message: Message(sender: userStore.user.nickname, content: message, timestamp: Date().timeIntervalSince1970))
                                message = ""
                chatRoomStore.sendMessage(myNickName: userStore.user.nickname, otherUserNickname: userStore.user.nickname == chatRoom.firstUserNickname ? chatRoom.secondUserNickname : chatRoom.firstUserNickname, message: Message(sender: userStore.user.nickname, content: message, timestamp: Date().timeIntervalSince1970))
                message = ""
            }
        }
                //MARK: contents
        //        HStack(alignment: .top) {
        //            HStack(alignment: .top) {
        //
        //                Text("\(feed.contents)")
        //                    .font(.pretendardRegular16)
        //                    .foregroundColor(.primary)
        //                    .padding(.top, 15)
        //            }
        //            .padding(.leading, .screenWidth/2 - .screenWidth*0.45 )
        //            Spacer()
        //            VStack {
        //                HStack{
        //                    //MARK: 내 글일땐 북마크 안 뜨게 하기
        //                    if feed.writerNickname != userStore.user.nickname {
        //                        Button {
        //                            if(userStore.user.myFeed.contains("\(feed.id)")) {
        //                                userStore.deleteFeed(feed)
        //                                userStore.user.myFeed.removeAll { $0 == "\(feed.id)" }
        //                                userStore.updateUser(user: userStore.user)
        //                                userStore.clickSavedCancelFeedToast = true
        //                            } else {
        //                                userStore.saveFeed(feed) //장소 저장 로직(사용가능)
        //                                userStore.user.myFeed.append("\(feed.id)")
        //                                userStore.updateUser(user: userStore.user)
        //                                userStore.clickSavedFeedToast = true
        //                            }
        //                        } label: {
        //                            if colorScheme == ColorScheme.dark {
        //                                Image(userStore.user.myFeed.contains("\(feed.id)") ? "bookmark_fill" : "bookmark_dark")
        //                                    .resizable()
        //                                    .scaledToFit()
        //                                    .frame(width: 20)
        //                                    .padding(.trailing, 5)
        //                            } else {
        //                                Image(userStore.user.myFeed.contains( "\(feed.id)" ) ? "bookmark_fill" : "bookmark_light")
        //                                    .resizable()
        //                                    .scaledToFit()
        //                                    .frame(width: 20)
        //                                    .padding(.trailing, 5)
        //                            }
        //                        }
        //                    }
        //                    //MARK: 내 글일땐 비행기 안 뜨게 하기
        //                    if feed.writerNickname != userStore.user.nickname {
        //                        Button {
        //                            withAnimation {
        //                                isShowingMessageTextField.toggle()
        //                            }
        //                        } label: {
        //                            Image(systemName: isShowingMessageTextField ? "paperplane.fill" : "paperplane")
        //                                .resizable()
        //                                .scaledToFit()
        //                                .frame(width: 20)
        //                                .font(.pretendardRegular14)
        //                                .foregroundColor(.white)
        //                                .padding(.horizontal, 25)
        //                                .padding(.vertical, 8)
        //                                .background(isShowingMessageTextField ? Color.privateColor : Color.darkGrayColor)
        //                                .cornerRadius(30)
        //                        }
        //                    }
        //                }
        //            }
        //            .font(.pretendardMedium24)
        //            .foregroundColor(.primary)
        //            .padding(.trailing,.screenWidth/2 - .screenWidth*0.45)
        //            //.disabled(true)
        //        }
        //        .padding(.top, -25)
        //        .padding(.bottom, 0)
        //
        HStack(alignment: .top) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    if isExpanded {
                        Text(feed.contents)
                            .font(.pretendardRegular16)
                            .foregroundColor(.primary)
                            .padding(.top, 5)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                            .padding(.bottom, 5)
                    } else {
                        TruncationDetectingText(text: feed.contents, isTruncated: $isTruncated)
                            .font(.pretendardRegular16)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .padding(.top, 5)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                            .padding(.bottom, 5)
                    }
                    if isTruncated {
                        Button(action: {
                            isExpanded.toggle()
                        }) {
                            Text(isExpanded ? "접기" : "더보기")
                                .foregroundColor(.accentColor)
                        }
                        .padding(.top, 5)
                    }
                }
                .padding(.leading, .screenWidth/2 - .screenWidth*0.45)
                
                Spacer()
                
                //.disabled(true)
            }
        }
        
        
        Divider()
            .padding(.vertical, 10)

    }
}
//MARK: UILabel의 실제 크기를 기반으로 isTruncated 값을 설정하여 "더보기" 버튼을 정확하게 표시or 숨기기 3줄 넘어가면 보여요
struct TruncationDetectingText: UIViewRepresentable {
    var text: String
    @Binding var isTruncated: Bool
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<Self>) {
        uiView.text = text
        DispatchQueue.main.async {
            self.isTruncated = uiView.isTruncated()
        }
    }
}
extension UILabel {
    func isTruncated() -> Bool {
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}
