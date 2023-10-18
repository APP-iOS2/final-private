//
//  MyPageView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var userStore: UserStore
    @Binding var root: Bool
    @Binding var selection: Int
    /// 각 버튼을 누르면 해당 화면을 보여주는 bool값
    @State var viewNumber: Int = 0
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "gearshape")
                        .padding(.trailing,30)
                        .foregroundColor(.primary)
                }
            }
            UserInfoView()
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
                .background(Color.primary)
                .padding(.top, -9)
            
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

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(root: .constant(true), selection: .constant(5)).environmentObject(UserStore())
    }
}
