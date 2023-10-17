//
//  OtherPageView.swift
//  Private
//
//  Created by 박범수 on 10/5/23.
//

import SwiftUI

struct OtherPageView: View {
    @EnvironmentObject private var userStore: UserStore
    @State var isMyhistoryButton: Bool = true
    @State var isMySavedFeedButton: Bool = false
    @State var isMySavedPlaceButton: Bool = false
    @State var viewNumber: Int = 0
    
    let user:User
    
    var body: some View {
        NavigationStack {
            OtherInfoView(user: user)
                .padding(.top,-15.0)
            HStack {
                Spacer()
                Button {
                    isMyhistoryButton = true
                    isMySavedFeedButton = false
                    isMySavedPlaceButton = false
                    viewNumber = 0
                }label: {
                    HStack {
                        isMyhistoryButton ? Image( systemName: "location.fill") : Image (systemName: "location")
                        Text("내 기록")
                    }
                    .font(.pretendardRegular12)
                    .foregroundColor(.chatTextColor)
                    .frame(width: .screenWidth*0.95*0.3)
                    .padding(.bottom,15.0)
                    .modifier(BottomBorder(showBorder: viewNumber == 0))
                }
                Button {
                    isMyhistoryButton = false
                    isMySavedFeedButton = true
                    isMySavedPlaceButton = false
                    viewNumber = 1
                }label: {
                    HStack {
                        isMySavedFeedButton ? Image(systemName: "bookmark.fill") : Image (systemName: "bookmark")
                        Text("내가 저장한 피드")
                    }.font(.pretendardRegular12)
                        .foregroundColor(.chatTextColor)
                        .frame(width: .screenWidth*0.95*0.3)
                        .padding(.bottom,15.0)
                        .modifier(BottomBorder(showBorder: viewNumber == 1))
                }
                Button {
                    isMyhistoryButton = false
                    isMySavedFeedButton = false
                    isMySavedPlaceButton = true
                    viewNumber = 2
                }label: {
                    HStack {
                        isMySavedPlaceButton ? Image(systemName: "pin.fill")
                        : Image (systemName: "pin")
                        Text("내가 저장한 장소")
                    }.font(.pretendardRegular12)
                        .foregroundColor(.chatTextColor)
                        .frame(width: .screenWidth*0.95*0.3)
                        .padding(.bottom,15.0)
                        .modifier(BottomBorder(showBorder: viewNumber == 2))
                }
                Spacer()
            }
            .padding(.top, 37)
            Divider()
                .background(Color.primary)
                .frame(width: .screenWidth*0.925)
                .padding(.top, -8)
            
            TabView(selection: $viewNumber) {
                OtherHistoryView(user: User(), otherFeedList: userStore.otherFeedList).tag(0)
                OtherSavedView(user: User(), otherSavedFeedList: userStore.otherSavedFeedList).tag(1)
                OtherSavedPlaceView(user: User(), otherSavedPlaceList: userStore.otherSavedPlaceList).tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
                .onAppear {
                    userStore.fetchotherUser(userEmail: user.email)
                }
        }
    }
}

