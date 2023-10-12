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
                    Text("\(feed.writerName)")
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
                    }.tag(image)
                }
            }.tabViewStyle(PageTabViewStyle())
                .frame(width: .screenWidth, height: .screenWidth)
      
            HStack(alignment: .top) {
                Text("\(feed.contents)")
                    .font(.pretendardRegular16)
                    .foregroundColor(.primary)
                    .frame(width: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                
                Group {
                    Button {
                        print("북마크, 피드 저장")
                    } label: {
                        Image(systemName: "bookmark")
                    }
                    Button {
                        print("DM 보내기")
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                .font(.pretendardMedium24)
                .foregroundColor(.primary)
                .frame(width: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                .padding(.bottom, 10)  // 글 내용과 아래 버튼 사이의 간격을 조정
                .padding(.leading,50)
            Group {
                Button {
                    print("북마크, 피드 저장")
                } label: {
                    Image(systemName: "bookmark")
                }
                Button {
                    print("DM 보내기")
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .font(.pretendardMedium24)
            .foregroundColor(.primary)
        }
        //            .padding(.top, 10)
        //            .padding(.leading, 20)  // 왼쪽 간격 추가
        .padding(.horizontal, 10)
        
        HStack {
            VStack {
                Image(systemName: "pin.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                Text("저장")
                    .font(.pretendardRegular14)
                    .foregroundColor(.primary)
                    .padding(.top, -5)
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
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
        .background(Color.darkGraySubColor)
    }
    //.padding(.top, 20)
}

