//
//  OtherProfileView.swift
//  Private
//
//  Created by 박범수 on 10/19/23.
//

import SwiftUI

struct OtherProfileView: View {
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var followStore: FollowStore
    /// 각 버튼을 누르면 해당 화면을 보여주는 bool값
    @State var viewNumber: Int = 0
    
    let user:User
    var body: some View {
        NavigationStack {
            OtherInfoView(user: user, followerList:followStore.followerList, followingList: followStore.followingList)
                .padding(.top,-20.0)
                .padding(.bottom, 20)
            HStack {
                NavigationLink {
                    MapMainView()
                } label: {
                    HStack {
                        Image(systemName: "map")
                        Text("내 마커")
                            .font(.pretendardRegular14)
                    }
                    .foregroundColor(.white)
                }
                .frame(width: .screenWidth*0.5)
                Divider()
                    .background(Color.white)
                    .frame(height: .screenHeight*0.02)
                NavigationLink {
                    MyReservation(isShowingMyReservation: .constant(true))
                } label: {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("예약내역")
                            .font(.pretendardRegular14)
                    }
                    .foregroundColor(.white)
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
                    .foregroundColor(viewNumber == 0 ? .privateColor : .white)
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
                            Image ("bookmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                        }
                        Text("저장한 피드")
                    }
                    .font(.pretendardRegular12)
                    .foregroundColor(viewNumber == 1 ? .privateColor : .white)
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
                    .foregroundColor(viewNumber == 2 ? .privateColor : .white)
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
        .navigationBarBackButtonHidden(true)
        .backButtonArrow()
    }
}
