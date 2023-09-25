//
//  FeedMainView.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI

struct FeedMainView: View {
    
    @EnvironmentObject var feedStore: FeedStore
    
    var body: some View {
        ScrollView {
            ForEach(feedStore.feedList) { feed in
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: feed.writer.profileImageURL)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        } placeholder: {
                            Image("userDefault")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(feed.writer.name)")
                            Text("\(feed.writer.nickname)")
                            Text("\(feed.createdAt)")
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    Image("\(feed.images[0])")
                        .resizable()
                        .scaledToFit()
                        .frame(height: .screenWidth)
                    HStack(alignment: .top) {
                        Text("\(feed.contents)")
                            .font(.pretendardRegular16)
                            .foregroundColor(.primary)
                            .frame(width: .screenWidth * 0.7, alignment: .leading)
                        
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
                    .padding(.top, 10)
                    
                    HStack {
                        VStack {
                            Image(systemName: "pin.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            Text("저장")
                                .font(.pretendardRegular14)
                                .foregroundColor(.primary)
                                .padding(.top, -5)
                        }
                        .padding(.leading, 15)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(feed.visitedShop.name)")
                                .font(.pretendardMedium16)
                                .foregroundColor(.primary)
                            Text("\(feed.visitedShop.address)")
                                .font(.pretendardRegular12)
                                .foregroundColor(.primary)
                        }
                        .padding(.leading, 15)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(width: .screenWidth * 0.9, height: 80)
                    .background(Color.darkGraySubColor)
                }
                .padding(.top, 20)
            }
        }
    }
}

struct FeedMainView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMainView()
            .environmentObject(FeedStore())
    }
}
