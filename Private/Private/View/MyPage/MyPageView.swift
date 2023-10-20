//
//  MyPageView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct MyPageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var followStore: FollowStore
    
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    @Binding var root: Bool
    @Binding var selection: Int
    /// 각 버튼을 누르면 해당 화면을 보여주는 bool값
    @State var viewNumber: Int = 0
    
    var body: some View {
        NavigationStack {
            HStack {
                if colorScheme == .dark {
                    Image("private_dark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .screenWidth * 0.35)
                } else {
                    Image("private_light")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .screenWidth * 0.35)
                }
                Spacer()
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "gearshape")
                        .padding(.top, 10)
                        .padding(.trailing,30)
                        .foregroundColor(.primary)
                }
            }
            UserInfoView(followerList: followStore.followerList, followingList: followStore.followingList)
                .padding(.top,-20.0)
                .padding(.bottom, 20)
            HStack {
                NavigationLink {
                    NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView, showMyMarkerDetailView: $coordinator.showMyMarkerDetailView,
                             markerTitle: $coordinator.newMarkerTitle,
                             markerTitleEdit: $coordinator.newMarkerAlert, coord: $coordinator.coord)
                    .sheet(isPresented: $coordinator.showMyMarkerDetailView) {
                        MapFeedSheetView(feed: userStore.myFeedList.filter { $0.id == coordinator.currentFeedId }[0])
                            .presentationDetents([.height(.screenHeight * 0.55)])
                    }
                } label: {
                    HStack {
                        Image(systemName: "map")
                        Text("내 마커")
                            .font(.pretendardRegular14)
                    }
                    .foregroundColor(.primary)
                }
                .frame(width: .screenWidth*0.5)
                
                Divider()
                    .background(Color.primary)
                    .frame(height: .screenHeight*0.02)
                NavigationLink {
                    MyReservation(isShowingMyReservation: .constant(true))
                } label: {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("예약내역")
                            .font(.pretendardRegular14)
                    }
                    .foregroundColor(.primary)
                }
                .frame(width: .screenWidth*0.5)
            }
            HStack {
                Button {
                    viewNumber = 0
                }label: {
                    HStack {
                        viewNumber == 0 ? Image( systemName: "location.fill") : Image (systemName: "location")
                        Text("내 피드")
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
                MyHistoryView().tag(0)
                MySavedView().tag(1)
                MySavedPlaceView().tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
               
        }
        .onAppear{
            followStore.fetchFollowerFollowingList(userStore.user.email)
            coordinator.checkIfLocationServicesIsEnabled()
            Coordinator.shared.myFeedList = userStore.myFeedList
            print("myFeedList: \(Coordinator.shared.myFeedList)")
            coordinator.makeOnlyMyFeedMarkers()
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(root: .constant(true), selection: .constant(5)).environmentObject(UserStore())
    }
}
