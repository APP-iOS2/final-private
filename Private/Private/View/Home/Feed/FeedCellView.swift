//
//  FeedCellView.swift
//  Private
//
//  Created by yeon on 10/10/23.
//

import SwiftUI
import NMapsMap

struct FeedCellView: View {
    var feed: MyFeed
    
    var body: some View {
        VStack {
            HStack {
//                AsyncImage(url: URL(string: feed.writer.profileImageURL)) { image in
//                    image
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50)
//                } placeholder: {
//                    Image("userDefault")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50)
//                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(feed.writer)")
                  
                    Text("\(feed.createdAt)")
                }
                Spacer()
            }
            .padding(.leading, 20)
            Image("\(feed.images[0])")
                .resizable()
                .scaledToFit()
                .frame(height: UIScreen.main.bounds.width) 
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
            .padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
            .background(Color.darkGraySubColor)
        }
        .padding(.top, 20)
    }
}
