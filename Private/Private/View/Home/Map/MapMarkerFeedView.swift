//
//  MapMarkerFeedView.swift
//  Private
//
//  Created by 변상우 on 10/6/23.
//

import SwiftUI

struct MapMarkerFeedView: View {
    
//    let feed: Feed
    let feed: MyFeed = MyFeed(writer: "boogios", images: ["userDefault"], contents: "아 맛있다", visitedShop: "광화문광장맛집", category: [])
    
    @State private var message: String = ""
    
    var body: some View {
        VStack {
            HStack {
//                AsyncImage(url: URL(string: feed.writer.profileImageURL)) { image in
                AsyncImage(url: URL(string: feed.writer)) { image in
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
//                    Text("\(feed.writer.name)")
//                    Text("\(feed.writer.nickname)")
//                    Text("\(feed.createdAt)")
                    Text("\(feed.writer)")
                    Text("\(feed.writer)")
                    Text("\(feed.createdAt)")
                }
                
                Spacer()
            }
            .padding(.leading, 20)
            
            HStack {
                Image("\(feed.images[0])")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .screenWidth * 0.35)
                    .padding(.trailing, 10)
                
                Text("\(feed.contents)")
                    .font(.pretendardRegular16)
                    .foregroundColor(.primary)
                    .frame(width: .screenWidth * 0.6, alignment: .leading)
            }
            .padding(.horizontal, 20)
            
            HStack {
                Group {
                    Button {
                        print("북마크, 피드 저장")
                    } label: {
                        Image(systemName: "pin.fill")
                    }
                    Button {
                        print("북마크, 피드 저장")
                    } label: {
                        Image(systemName: "bookmark")
                    }
                }
                .font(.pretendardMedium24)
                .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    print("DM 보내기")
                } label: {
                    Image(systemName: "paperplane")
                        .font(.pretendardMedium24)
                        .foregroundColor(.primary)
                }
            }
            
            SendMessageTextField(text: $message, placeholder: "메시지를 입력하세요") {
                print("메시지 전송")
            }
        }
    }
}

//struct MapMarkerFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapMarkerFeedView(feed: Fee)
//    }
//}
