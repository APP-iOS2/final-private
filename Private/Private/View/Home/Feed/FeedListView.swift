//
//  FeedListView.swift
//  Private
//
//  Created by yeon on 10/10/23.
//


import SwiftUI
import NMapsMap


struct FeedListView: View {
    @EnvironmentObject var feedStore : FeedStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(feedStore.feedList) { feed in
                    FeedCellView(feed: feed, filteredFeedList: [MyFeed]())
                }
            }
            .navigationBarTitle("팔로워의 리뷰", displayMode: .inline)
        }
    }
}
