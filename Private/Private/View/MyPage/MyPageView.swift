//
//  MyPageView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var userStore: UserStore
    @GestureState private var swipeOffset: CGFloat = 0.0
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
                .padding(.top,-15.0)
//            Divider()
//                .background(Color.primary)
//                .frame(width: .screenWidth*0.9)
//                .padding([.top,.bottom],15)
            HStack {
                Spacer()
                Button {
                    viewNumber = 0
                }label: {
                    HStack {
                        viewNumber == 0 ? Image( systemName: "location.fill") : Image (systemName: "location")
                        Text("내 기록")
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
                        Text("내가 저장한 피드")
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
            /*switch viewNumber {
            case 0:
                MyHistoryView()
                    .gesture(
                        DragGesture()
                            .updating($swipeOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                if value.translation.width < -50 {
                                    // 스와이프 제스처를 위로 움직였을 때 뷰 전환
                                    isMyhistoryButton = false
                                    isMySavedFeedButton = true
                                    isMySavedPlaceButton = false
                                    viewNumber = 1
                                }
                            }
                    )
            case 1:
                MySavedView()
                    .padding(.top,37.2)
                // MyHistorView 의 피드 지도 버튼 간격을 맞추기 위한 패딩
                    .gesture(
                        DragGesture()
                            .updating($swipeOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                if value.translation.width < -50 {
                                    // 스와이프 제스처를 위로 움직였을 때 뷰 전환
                                    isMyhistoryButton = false
                                    isMySavedFeedButton = false
                                    isMySavedPlaceButton = true
                                    viewNumber = 2
                                }
                            }
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    // 스와이프 제스처를 위로 움직였을 때 뷰 전환
                                    isMyhistoryButton = true
                                    isMySavedFeedButton = false
                                    isMySavedPlaceButton = false
                                    viewNumber = 0
                                }
                            }
                    )
            case 2:
                MySavedPlaceView()
                    .gesture(
                        DragGesture()
                            .updating($swipeOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    // 스와이프 제스처를 위로 움직였을 때 뷰 전환
                                    isMyhistoryButton = false
                                    isMySavedFeedButton = true
                                    isMySavedPlaceButton = false
                                    viewNumber = 1
                                }
                            }
                    )
            default:
                MyHistoryView()
            }*/
            TabView(selection: $viewNumber) {
                MyHistoryView().tag(0)
                MySavedView().tag(1)
                MySavedPlaceView().tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            Spacer()
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(root: .constant(true), selection: .constant(5)).environmentObject(UserStore())
    }
}
