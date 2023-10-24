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
    @Binding var isMyPageFeedSheet: Bool
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    @EnvironmentObject private var userStore: UserStore
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared
    @ObservedObject var detailCoordinator = DetailCoordinator.shared

    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    @State private var isShowingLocation: Bool = false
    @State private var lat: String = ""
    @State private var lng: String = ""
    @State private var currentPicture: Int = 0
    var feed: MyFeed
    var feedList:[MyFeed]
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button {
                    isMyPageFeedSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .padding()
            Divider()
                .background(Color.primary)
            ScrollView {
                ScrollViewReader { ScrollViewProxy in
                    ForEach(feedList, id: \.self) { feedListFeed in
                        VStack{
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
                                }
                                .padding(.leading, 20)
                                
                                TabView(selection: $currentPicture) {
                                    ForEach(feedListFeed.images, id: \.self) { image in
                                        KFImage(URL(string: image )) .placeholder {
                                            Image(systemName: "photo")
                                        }
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)  // 너비와 높이를 화면 너비의 90%로 설정
                                        .clipped()
                                        .padding(.bottom, 10)  // 아래쪽에 10포인트의 패딩 추가
                                        .padding([.leading, .trailing], 15)  // 좌우에 15포인트의 패딩 추가
                                        .tag(Int(feedListFeed.images.firstIndex(of: image) ?? 0))
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                            }
                            .padding(.top, 8)
                            .frame(width: .screenWidth, height: .screenWidth)
                            VStack(alignment: .leading) {
                                HStack {
                                    HStack (alignment: .top) {
                                        Text("\(feedListFeed.contents)")
                                            .font(.pretendardRegular16)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.leading, .screenWidth/2 - .screenWidth*0.45 )
                                    Spacer()
                                }
                                HStack {
                                    Button {
                                        if (userStore.user.bookmark.contains("\(feedListFeed.id)")) {
                                            userStore.deletePlace(feedListFeed)
                                            userStore.user.bookmark.removeAll { $0 == "\(feedListFeed.id)" }
                                            userStore.updateUser(user: userStore.user)
                                            userStore.clickSavedCancelPlaceToast = true
                                        } else {
                                            userStore.savePlace(feedListFeed) //장소 저장 로직(사용가능)
                                            userStore.user.bookmark.append("\(feedListFeed.id)")
                                            userStore.updateUser(user: userStore.user)
                                            userStore.clickSavedPlaceToast = true
                                        }
                                    } label: {
                                        Image(systemName: userStore.user.bookmark.contains("\(feedListFeed.id)") ? "pin.fill": "pin")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                        //                    .foregroundColor(.primary)
                        //                    .foregroundColor(userStore.user.bookmark.contains("\(feed.images[0].suffix(32))") ? .privateColor : .primary)
                                        //MARK: 인덱스 벗어난대서 이렇게 고치니까 돌?아가지더라고요
                                            .padding(.top, 5)
                                            .foregroundColor(
                                                        (feedListFeed.images.count > 0 && userStore.user.bookmark.contains("\(feedListFeed.images[0].suffix(32))"))
                                                        ? .privateColor
                                                        : .primary
                                                    )
                                    }
                                    .padding(.leading, 15)
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
                                        .padding(.leading, 15)
                                    }
                                    Spacer()
                                }
                                .padding(.top, 5)
                                .padding(.horizontal, 10)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
                                .background(Color.darkGraySubColor)
                                .sheet(isPresented: $isShowingLocation) {
                                    LocationDetailView(searchResult: $searchResult)
                                        .presentationDetents([.height(.screenHeight * 0.6), .large])
                                }
                            }
                            .padding(.top,20)
                            .padding(.leading, .screenWidth/2 - .screenWidth*0.45)
                        }
                        .id(feedList.firstIndex(of: feedListFeed))
                        .padding(.bottom, 60)
                        Divider()
                        Spacer ()
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

struct MyPageFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageFeedView(isMyPageFeedSheet: .constant(true), feed: MyFeed(), feedList: [MyFeed()])
    }
}
