//
//  OtherPage.swift
//  Private
//
//  Created by 박범수 on 10/18/23.
//

import SwiftUI

struct OtherPage: View {
    @EnvironmentObject private var userStore: UserStore
    @ObservedObject var followStore: FollowStore
    /// 각 버튼을 누르면 해당 화면을 보여주는 bool값
    @State var viewNumber: Int = 0
    let user: User
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
            }
//            UserInfoView(followStore: followStore, user: user)
            UserInfoView()
                .padding(.top,-15.0)
            HStack {
                Spacer()
                Button {
                    viewNumber = 0
                }label: {
                    HStack {
                        viewNumber == 0 ? Image( systemName: "location.fill") : Image (systemName: "location")
                        Text("기록")
                    }
                    .font(.pretendardRegular12)
                    .foregroundColor(.chatTextColor)
                    .frame(width: .screenWidth*0.95*0.3)
                    .padding(.bottom,15.0)
                    .modifier(BottomBorder(showBorder: viewNumber == 0))
                }
                Spacer()
                Button {
                    viewNumber = 1
                }label: {
                    HStack {
                        viewNumber == 1 ? Image(systemName: "bookmark.fill") : Image (systemName: "bookmark")
                        Text("저장한 피드")
                    }.font(.pretendardRegular12)
                        .foregroundColor(.chatTextColor)
                        .frame(width: .screenWidth*0.95*0.3)
                        .padding(.bottom,15.0)
                        .modifier(BottomBorder(showBorder: viewNumber == 1))
                }
                Spacer()
                Button {
                    viewNumber = 2
                }label: {
                    HStack {
                        viewNumber == 2 ? Image(systemName: "pin.fill")
                        : Image (systemName: "pin")
                        Text("저장한 장소")
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
                MyHistoryView().tag(0)
                MySavedView().tag(1)
                MySavedPlaceView().tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
        }
    }
}
