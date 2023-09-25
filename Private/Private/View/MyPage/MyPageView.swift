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
    @State var isMyhistoryButton: Bool = true
    @State var isMySavedFeedButton: Bool = false
    @State var isMySavedPlaceButton: Bool = false
    @State var viewNumber: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "gearshape")
                    .padding(.trailing,40)
            }
            UserInfoView()
                
            
            Divider()
                .background(Color.white)
                .frame(width: .screenWidth*0.9)
                .padding([.top,.bottom],15)
                
            HStack {
                Spacer()
                Button(action: {
                    isMyhistoryButton = true
                    isMySavedFeedButton = false
                    isMySavedPlaceButton = false
                    viewNumber = 0
                },label: {
                    HStack {
                        isMyhistoryButton ? Image( systemName: "location.fill") : Image (systemName: "location")
                        Text("내 기록")
                    }.font(.pretendardRegular12)
                        .foregroundColor(.white)
                        .frame(width: .screenWidth*0.95*0.3)
                })
                
                Button(action: {
                    isMyhistoryButton = false
                    isMySavedFeedButton = true
                    isMySavedPlaceButton = false
                    viewNumber = 1
                },label: {
                    HStack {
                        isMySavedFeedButton ? Image( systemName: "bookmark.fill") : Image (systemName: "bookmark")
                        Text("내가 저장한 피드")
                    }.font(.pretendardRegular12)
                        .foregroundColor(.white)
                        .frame(width: .screenWidth*0.95*0.3)
                })
                
                Button(action: {
                    isMyhistoryButton = false
                    isMySavedFeedButton = false
                    isMySavedPlaceButton = true
                    viewNumber = 2
                },label: {
                    HStack {
                        isMySavedPlaceButton ? Image( systemName: "pin.fill")
                        : Image (systemName: "pin")
                        Text("내가 저장한 장소")
                    }.font(.pretendardRegular12)
                        .foregroundColor(.white)
                        .frame(width: .screenWidth*0.95*0.3)
                })
                Spacer()
            }
            
            
            HStack {
                isMyhistoryButton ?
                Rectangle()
                    .frame(width: .screenWidth*0.95*0.3, height: 1)
                :
                Rectangle()
                    .frame(width: .screenWidth*0.95*0.3, height: 0)
                isMySavedFeedButton ?
                Rectangle()
                    .frame(width: .screenWidth*0.95*0.3, height: 1)
                :
                Rectangle()
                    .frame(width: .screenWidth*0.95*0.3, height: 0)
                isMySavedPlaceButton ?
                Rectangle()
                    .frame(width: .screenWidth*0.95*0.3, height: 1)
                :
                Rectangle()
                    .frame(width: .screenWidth*0.95*0.3, height: 0)
            }
            .padding([.top,.bottom], 5)
            
           
                switch viewNumber {
                case 0:
                    MyHistoryView()
                case 1:
                    MySavedView()
                case 2:
                    MySavedPlaceView()
                default:
                    MyHistoryView()
                }
            
            Spacer()
        }
       
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(root: .constant(true), selection: .constant(5))
    }
}
