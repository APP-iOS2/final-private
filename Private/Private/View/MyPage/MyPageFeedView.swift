//
//  MyPageFeedView.swift
//  Private
//
//  Created by 주진형 on 10/13/23.
//

import SwiftUI
import Kingfisher

struct MyPageFeedView: View {
    @Binding var isMyPageFeedSheet: Bool
    @State private var currentPicture: Int = 0
    @State private var isEnlarge: Bool = false
    var feed: MyFeed
    var body: some View {
        NavigationStack {
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
                        if isEnlarge == false {
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
                            .onTapGesture {
                                isEnlarge.toggle()
                            }
                        } else {
                            KFImage(URL(string: image)) .placeholder {
                                Image(systemName: "photo")
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)  // 너비와 높이를 화면 너비의 90%로 설정
                            .clipped()
                            .padding(.bottom, 10)  // 아래쪽에 10포인트의 패딩 추가
                            .padding([.leading, .trailing], 15)  // 좌우에 15포인트의 패딩 추가
                            .tag(Int(feed.images.firstIndex(of: image) ?? 0))
                            .onTapGesture {
                                isEnlarge.toggle()
                            }
                        }
                    }
                    //.tag()
                }
                .tabViewStyle(PageTabViewStyle())
            }
            .padding(.top, 15)
            .frame(width: .screenWidth, height: .screenWidth)
            
            HStack() {
                Text("\(feed.contents)")
                    .font(.pretendardRegular16)
                    .foregroundColor(.primary)
                    .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
            }
            .padding(.top,20)
            Spacer ()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isMyPageFeedSheet = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                        }
                    }
                }
        }
    }
}

struct MyPageFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageFeedView(isMyPageFeedSheet: .constant(true), feed: MyFeed())
    }
}
