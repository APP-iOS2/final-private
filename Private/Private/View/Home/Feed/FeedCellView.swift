//
//  FeedCellView.swift
//  Private
//
//  Created by yeon on 10/10/23.
//

import SwiftUI
import NMapsMap
import Kingfisher

struct FeedCellView: View {
    var feed: MyFeed
  
    @State private var currentPicture = 0
    @EnvironmentObject private var userStore: UserStore // 피드,장소 저장하는 함수 사용하기 위해서 선언

    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: feed.writerProfileImage))
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
                    Text("\(feed.writerNickname)")
                        .font(.headline)
                    //Text("\(feed.writerName)")
                    Text("\(feed.createdDate)")
                    
                }
                Spacer()
            }
            .padding(.leading, 20)
            
            TabView(selection: $currentPicture) {
                ForEach(feed.images, id: \.self) { image in
                    KFImage(URL(string: image )) .placeholder {
                        Image(systemName: "photo")
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)  // 너비와 높이를 화면 너비의 90%로 설정
                    .clipped()
                    .padding(.bottom, 10)  // 아래쪽에 10포인트의 패딩 추가
                    .padding([.leading, .trailing], 15)  // 좌우에 15포인트의 패딩 추가
                    .tag(Int(feed.images.firstIndex(of: image) ?? 0))
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(width: .screenWidth, height: .screenWidth)
        }
        

        HStack(alignment: .top){
            HStack(alignment: .top) {
                Text("\(feed.contents)")
                    .font(.pretendardRegular16)
                    .foregroundColor(.primary)
               
            }
           
            .padding(.leading, 30)
            Spacer()
          VStack {
              
              HStack{
                  Button {
                      print("북마크, 피드 저장")
                      userStore.savePlace(feed) //장소 저장 로직(사용가능)
                  } label: {
                      Image(systemName: "bookmark")
                  }
                  Button {
                      userStore.saveFeed(feed) //피드 저장 로직 (사용가능)
                      print("DM 보내기")
                  } label: {
                      Image(systemName: "paperplane")
                  }
              }
            }
            .font(.pretendardMedium24)
            .foregroundColor(.primary)
            .padding(.trailing,15)
        }
        .padding(.top, 10)
       
        HStack {
                Button {
                    print("핀, 장소 저장")
                    userStore.savePlace(feed) //장소 저장 로직(사용가능)
                } label: {
                    Image(systemName: "pin.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.primary)
                        .padding(.top, 5)

            }
            .padding(.leading, 15)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(feed.title)")
                    .font(.pretendardMedium16)
                    .foregroundColor(.primary)
                Text("\(feed.roadAddress)")
                    .font(.pretendardRegular12)
                    .foregroundColor(.primary)
            }
            .padding(.leading, 15)
            Spacer()
        }
        .padding(.top, 5)
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
        .background(Color.darkGraySubColor)
    }
    //.padding(.top, 20)
}

