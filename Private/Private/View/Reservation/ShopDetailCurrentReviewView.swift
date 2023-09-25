//
//  ShopDetailCurrentReviewView.swift
//  Private
//
//  Created by H on 2023/09/25.
//

import SwiftUI

struct ShopwDetailCurrentReviewView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<20) { index in
                        VStack(spacing: 10) {
                            ShopDetailCurrentReviewCell()
                            if index != 19 {
                                Divider()
                            }
                        }
                        .padding([.horizontal, .bottom], 10)
                    }
                }
            }
        }
    }
}

struct ShopDetailCurrentReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ShopwDetailCurrentReviewView()
    }
}

/*
 static let feed = Feed(
     writer: UserStore.user,
     images: [""],
     contents: "맛있는 맛집이에요",
     visitedShop: ShopStore.shop,
     category: [Category.koreanFood]
 )
 */

struct ShopDetailCurrentReviewCell: View {
    
    let dummyFeed = FeedStore.feed
    let dummyFeedImageString: String = "https://image.bugsm.co.kr/album/images/500/40912/4091237.jpg"
    let dummyUserImageString: String = "https://i.pinimg.com/564x/d7/fd/a8/d7fda819308b8998288990b28e7f509d.jpg"
    
    @State var isHearted: Bool = false
    @State var isBookmarked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                AsyncImage(url: URL(string: dummyUserImageString)!) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 70, height: 70)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(dummyFeed.writer.name)")
                        .font(Font.pretendardBold18)
                    Text("@\(dummyFeed.writer.nickname)")
                        .font(Font.pretendardRegular16)
                }
                
                Spacer()
                
                Button {
                    print(#function)
                    isHearted.toggle()
                } label: {
                    Image(systemName: isHearted ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(Color.black)
                }

                Button {
                    print(#function)
                    isBookmarked.toggle()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(Color.black)
                }
            }
            
            HStack(alignment: .top, spacing: 10) {
                AsyncImage(url: URL(string: dummyFeedImageString)!) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 170, height: 170)
                
                Text(dummyFeed.contents)
                    .font(Font.pretendardRegular16)
            }
        }
    }
}
