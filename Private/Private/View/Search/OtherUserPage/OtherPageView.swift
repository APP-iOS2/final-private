//
//  OtherPageView.swift
//  Private
//
//  Created by 박범수 on 10/5/23.
//

import SwiftUI

struct OtherPageView: View {
    @GestureState private var swipeOffset: CGFloat = 0.0
    /// 각 버튼을 누르면 해당 화면을 보여주는 bool값
    @State var isMyhistoryButton: Bool = true
    @State var isMySavedFeedButton: Bool = false
    @State var isMySavedPlaceButton: Bool = false
    @State var viewNumber: Int = 0
    let user:User
    
    var body: some View {
        NavigationStack {
            OtherInfoView(user: user)
                .padding(.top,-15.0)
            Divider()
                .background(Color.primary)
                .frame(width: .screenWidth*0.9)
                .padding([.top,.bottom],15)
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
            switch viewNumber {
            case 0:
                OtherHistoryView(user: user)
                    .gesture(
                        DragGesture()
                            .updating($swipeOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                if value.translation.width < -50 {
                                    // 스와이프 제스처를 위로 움직였을 때 뷰 전환
                                    viewNumber = 1
                                }
                            }
                    )
            case 1:
                OtherSavedView(user: user)
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
                                    viewNumber = 2
                                }
                            }
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    // 스와이프 제스처를 위로 움직였을 때 뷰 전환
                                    viewNumber = 0
                                }
                            }
                    )
            case 2:
                OtherSavedView(user: user)
                    .gesture(
                        DragGesture()
                            .updating($swipeOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                if value.translation.width > 50 {
                                    // 스와이프 제스처를 위로 움직였을 때 뷰 전환
                                    viewNumber = 1
                                }
                            }
                    )
            default:
                OtherHistoryView(user: user)
            }
            Spacer()
        }
    }
}

