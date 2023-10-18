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
    var feedList:[MyFeed]
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button {
                    isMyPageFeedSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                }
            }
            .padding()
            
            ScrollView {
                ScrollViewReader { ScrollViewProxy in
                    ForEach(feedList, id: \.self) { feedListFeed in
                        VStack{
                            VStack {
                                HStack {
                                    KFImage(URL(string: feedListFeed.writerProfileImage))
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
                                        Text("\(feedListFeed.writerNickname)")
                                            .font(.pretendardSemiBold16)
                                        Text("\(feedListFeed.createdDate)")
                                            .font(.pretendardRegular12)
                                            .foregroundColor(.primary.opacity(0.8))
                                    }
                                    Spacer()
                                }
                                .padding(.leading, 20)
                                
                                TabView(selection: $currentPicture) {
                                    ForEach(feedListFeed.images, id: \.self) { image in
                                        KFImage(URL(string: image )) .placeholder {
                                            Image(systemName: "photo")
                                        }
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)  // 너비와 높이를 화면 너비의 90%로 설정
                                        .clipped()
                                        .padding(.bottom, 10)  // 아래쪽에 10포인트의 패딩 추가
                                        .padding([.leading, .trailing], 15)  // 좌우에 15포인트의 패딩 추가
                                        .tag(Int(feedListFeed.images.firstIndex(of: image) ?? 0))
                                        .onTapGesture {
                                            isEnlarge.toggle()
                                        }
                                    }
                                    //.tag()
                                }
                                .tabViewStyle(PageTabViewStyle())
                            }
                            .padding(.top, 8)
                            .frame(width: .screenWidth, height: .screenWidth)
                            HStack(alignment: .top) {
                                Text("\(feedListFeed.contents)")
                                    .font(.pretendardRegular16)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(.top,20)
                            .padding(.leading, .screenWidth/2 - .screenWidth*0.45)
                        }
                        .id(feedList.firstIndex(of: feedListFeed))
                        .padding(.bottom, 60)
                        Spacer ()
                    }
                    .onAppear{
                        withAnimation {
                            ScrollViewProxy.scrollTo(feedList.firstIndex(of:feed) ,anchor: .top)
                        }
                    }
                    
                }
            }
        }
    }
}

struct MyPageFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageFeedView(isMyPageFeedSheet: .constant(true), feed: MyFeed(), feedList: [MyFeed()])
    }
}
