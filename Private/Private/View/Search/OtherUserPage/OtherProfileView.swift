//
//  OtherProfileView.swift
//  Private
//
//  Created by 박범수 on 10/20/23.
//

import SwiftUI

struct OtherProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var followStore: FollowStore
    
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    /// 각 버튼을 누르면 해당 화면을 보여주는 bool값
    @State var viewNumber: Int = 0
    let user:User
    var body: some View {
        NavigationStack {
            OtherInfoView(followerList: followStore.followerList, followingList: followStore.followingList, user: user)
                .padding(.top,-20.0)
                .padding(.bottom, 20)
            HStack {
                NavigationLink {
                    NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView,
                             markerTitle: $coordinator.newMarkerTitle,
                             markerTitleEdit: $coordinator.newMarkerAlert, coord: $coordinator.coord)
                    .sheet(isPresented: $coordinator.showMyMarkerDetailView) {
                        MapFeedSheetView(feed: userStore.otherFeedList.filter { $0.id == coordinator.currentFeedId }[0])
                            .presentationDetents([.height(.screenHeight * 0.55)])
                    }
                } label: {
                    HStack {
                        Image(systemName: "map")
                            .foregroundStyle(Color("AccentColor"))
                        Text("\(user.nickname)님의 마커 보기")
                            .font(.pretendardRegular14)
                    }
                    .foregroundColor(.primary)
                }
                .frame(width: .screenWidth*0.9)
            }
            HStack {
                Button {
                    viewNumber = 0
                }label: {
                    HStack {
                        viewNumber == 0 ? Image( systemName: "location.fill") : Image (systemName: "location")
                        Text("피드")
                    }
                    .font(.pretendardRegular12)
                    .foregroundColor(viewNumber == 0 ? .privateColor : .primary)
                    .frame(width: .screenWidth*0.3)
                    .padding(.bottom, 15)
                    .modifier(YellowBottomBorder(showBorder: viewNumber == 0))
                }
                Spacer()
                Button {
                    viewNumber = 1
                }label: {
                    HStack {
                        if viewNumber == 1 {
                            Image("bookmark_fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                        } else {
                            if colorScheme == ColorScheme.dark {
                                Image ("bookmark_dark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                            } else {
                                Image ("bookmark_light")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15)
                            }
                        }
                        Text("저장한 피드")
                    }
                    .font(.pretendardRegular12)
                    .foregroundColor(viewNumber == 1 ? .privateColor : .primary)
                    .frame(width: .screenWidth*0.3)
                    .padding(.bottom, 15)
                    .modifier(YellowBottomBorder(showBorder: viewNumber == 1))
                }
                Spacer()
                Button {
                    viewNumber = 2
                }label: {
                    HStack {
                        viewNumber == 2 ? Image(systemName: "pin.fill") : Image (systemName: "pin")
                        Text("저장한 장소")
                    }
                    .font(.pretendardRegular12)
                    .foregroundColor(viewNumber == 2 ? .privateColor : .primary)
                    .frame(width: .screenWidth*0.3)
                    .padding(.bottom, 15)
                    .modifier(YellowBottomBorder(showBorder: viewNumber == 2))
                }
            }
            .padding(.top, 20)
            Divider()
                .background(Color.white)
                .padding(.top, -9)
            
            TabView(selection: $viewNumber) {
                OtherHistoryView(user: user).tag(0)
                OtherSavedView(user: user).tag(1)
                OtherSavedPlaceView(user: user).tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
               
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("\(user.nickname)")
        .backButtonArrow()
        .onAppear{
            userStore.fetchotherUser(userEmail: user.email)
            followStore.fetchFollowerFollowingList(user.email)
            coordinator.checkIfLocationServicesIsEnabled()
            Coordinator.shared.myFeedList = userStore.otherFeedList
            print("myFeedList: \(Coordinator.shared.myFeedList)")
//            coordinator.makeOnlyMyFeedMarkers()
        }
    }
}
