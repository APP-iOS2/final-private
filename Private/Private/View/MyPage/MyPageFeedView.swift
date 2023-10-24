//
//  MyPageFeedView.swift
//  Private
//
//  Created by 주진형 on 10/13/23.
//

import SwiftUI
import Kingfisher
import NMapsMap

struct MyPageFeedView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var feedStore: FeedStore
    
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared
    @ObservedObject var detailCoordinator = DetailCoordinator.shared
    
    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    @State private var isShowingLocation: Bool = false
    @State private var lat: String = ""
    @State private var lng: String = ""
    @State private var currentPicture: Int = 0
    @State private var isActionSheetPresented: Bool = false
    @State private var isFeedUpdateViewPresented: Bool = false
    @State private var isChangePlaceColor: Bool = false
    
    @Binding var isMyPageFeedSheet: Bool
    @Binding var root: Bool
    @Binding var selection: Int
    
    var feed: MyFeed
    var feedList: [MyFeed]
    var isMyFeedList: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button {
                    isMyPageFeedSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(.private))
                }
            }
            .padding()
            Divider()
                .background(Color.primary)
            ScrollView {
                ScrollViewReader { ScrollViewProxy in
                    ForEach(feedList, id: \.self) { feedListFeed in
                        VStack(alignment: .leading) {
                            VStack {
                                HStack {
                                    KFImage(URL(string: feedListFeed.writerProfileImage))
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
                                        Text("\(feedListFeed.writerNickname)")
                                            .font(.pretendardSemiBold16)
                                            .foregroundColor(.primary)
                                        Text("\(feedListFeed.createdDate)")
                                            .font(.pretendardRegular12)
                                            .foregroundColor(.primary.opacity(0.8))
                                    }
                                    Spacer()
                                    HStack {
                                        HStack {
                                            if (isMyFeedList) {
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
                                                                //MARK: FeedCellView에서 수정하는 곳
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
                                }
                                .padding(.leading, 20)
                                .padding(.bottom, 5)
                                
                                TabView(selection: $currentPicture) {
                                    ForEach(feedListFeed.images, id: \.self) { image in
                                        KFImage(URL(string: image )) .placeholder {
                                            Image(systemName: "photo")
                                        }
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: .screenWidth, height: .screenWidth)
                                        .clipped()
                                        .padding(.bottom, 10)  // 아래쪽에 10포인트의 패딩 추가
                                        .tag(Int(feedListFeed.images.firstIndex(of: image) ?? 0))
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                                .frame(width: .screenWidth, height: .screenWidth)
                            }
                            .padding(.bottom, 10)
                            
                            HStack {
                                HStack {
                                    Button {
                                        if (userStore.user.bookmark.contains("\(feedListFeed.id)")) {
                                            userStore.deletePlace(feedListFeed)
                                            userStore.user.bookmark.removeAll { $0 == "\(feedListFeed.id)" }
                                            userStore.updateUser(user: userStore.user)
                                            userStore.clickSavedCancelPlaceToast = true
                                            isChangePlaceColor.toggle()
                                        } else {
                                            userStore.savePlace(feedListFeed) //장소 저장 로직(사용가능)
                                            userStore.user.bookmark.append("\(feedListFeed.id)")
                                            userStore.updateUser(user: userStore.user)
                                            userStore.clickSavedPlaceToast = true
                                            isChangePlaceColor.toggle()
                                        }
                                    } label: {
                                        Image(systemName: userStore.user.bookmark.contains("\(feedListFeed.id)") ? "pin.fill": "pin")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .padding(.horizontal, 10)
                                            .foregroundColor(userStore.user.bookmark.contains("\(feedListFeed.id)") ? .privateColor : .primary)
                                    }
                                    .padding(.leading, 5)
                                    Button {
                                        isShowingLocation = true
                                        lat = locationSearchStore.formatCoordinates(feedListFeed.mapy, 2) ?? ""
                                        lng = locationSearchStore.formatCoordinates(feedListFeed.mapx, 3) ?? ""
                                        detailCoordinator.coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
                                        postCoordinator.newMarkerTitle = feedListFeed.title
                                        searchResult.title = feedListFeed.title
                                    } label: {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("\(feedListFeed.title)")
                                                .font(.pretendardMedium16)
                                                .foregroundColor(.primary)
                                            Text("\(feedListFeed.roadAddress)")
                                                .font(.pretendardRegular12)
                                                .foregroundColor(.primary)
                                        }
                                        .padding(.leading, 10)
                                    }
                                }
                                .padding(.horizontal, 10)
                                
                                .sheet(isPresented: $isShowingLocation) {
                                    LocationDetailView(searchResult: $searchResult)
                                        .presentationDetents([.height(.screenHeight * 0.6), .large])
                                }
                                Spacer()
                                
                                HStack {
                                    if (!isMyFeedList) {
                                        Divider()
                                        
                                        Button {
                                            if(userStore.user.myFeed.contains("\(feedListFeed.id)")) {
                                                userStore.deleteSavedFeed(feedListFeed)
                                                userStore.user.myFeed.removeAll { $0 == "\(feedListFeed.id)" }
                                                userStore.updateUser(user: userStore.user)
                                                userStore.clickSavedCancelFeedToast = true
                                            } else {
                                                userStore.saveFeed(feedListFeed) //장소 저장 로직(사용가능)
                                                userStore.user.myFeed.append("\(feedListFeed.id)")
                                                userStore.updateUser(user: userStore.user)
                                                userStore.clickSavedFeedToast = true
                                            }
                                        } label: {
                                            if colorScheme == ColorScheme.dark {
                                                Image(userStore.user.myFeed.contains("\(feedListFeed.id)") ? "bookmark_fill" : "bookmark_dark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20)
                                                    .padding(.trailing, 5)
                                            } else {
                                                Image(userStore.user.myFeed.contains( "\(feedListFeed.id)" ) ? "bookmark_fill" : "bookmark_light")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20)
                                                    .padding(.trailing, 5)
                                            }
                                        }
                                    }
                                }
                                .font(.pretendardMedium24)
                                .foregroundColor(.primary)
                                .padding(.trailing)
                            }
                            .padding(.vertical,20)
                            .background(Color.darkGraySubColor)
                            
                            
                            VStack(alignment: .leading) {
                                Text("\(feedListFeed.contents)")
                                    .font(.pretendardRegular16)
                                    .foregroundStyle(Color.primary)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 10)
                            }
                        }
                        .id(feedList.firstIndex(of: feedListFeed))
                        Divider()
                            .padding(.vertical, 10)
                    }
                    .onAppear{
                        withAnimation {
                            ScrollViewProxy.scrollTo(feedList.firstIndex(of:feed) ,anchor: .top)
                        }
                    }
                }
            }
        }
    }
}
