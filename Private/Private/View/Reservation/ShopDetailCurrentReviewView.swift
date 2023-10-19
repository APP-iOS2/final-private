//
//  ShopDetailCurrentReviewView.swift
//  Private
//
//  Created by H on 2023/09/25.
//

import SwiftUI
import NMapsMap
import Kingfisher
import ExpandableText

struct ShopwDetailCurrentReviewView: View {
    
    @EnvironmentObject var feedStore: FeedStore

    let shopData: Shop
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(feedStore.feedList.filter({ feed in
                        return feed.title == shopData.name
                    }), id: \.self) { feed in
                        VStack(spacing: 10) {
                            ShopDetailCurrentReviewCell(feed: feed)
                            Divider()
                                .padding(.top, 7)
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
        }
    }
}

struct ShopDetailCurrentReviewCell: View {
    
    @EnvironmentObject var feedStore: FeedStore
    
    @State var isBookmarked: Bool = false
    
    let feed: MyFeed
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                if let url = URL(string: feed.writerProfileImage) {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(feed.writerNickname)")
                        .font(Font.pretendardBold18)
                }
                
                Spacer()
            }
            
            HStack(alignment: .top, spacing: 10) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(feed.images, id: \.self) { imageURL in
                            KFImage(URL(string: imageURL)!)
                                .placeholder({
                                    ProgressView()
                                })
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                        }
                    }
                }
                .frame(width: 150, height: 150)
                
                ExpandableText(text: feed.contents)
                    .font(.pretendardRegular14)
                    .lineLimit(9)
                    .expandAnimation(.easeOut)
                    .expandButton(TextSet(text: "더보기", font: .pretendardRegular16, color: .blue))
                    .collapseButton(TextSet(text: "접기", font: .pretendardRegular16, color: .blue))
            }
        }
    }
}
