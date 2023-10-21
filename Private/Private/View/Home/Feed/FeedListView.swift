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
    @Binding var root: Bool
    @Binding var selection: Int
//    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    var body: some View {
        NavigationView {
            List {
                ForEach(feedStore.feedList, id:\.self) { feed in
                    FeedCellView(feed: feed, root:$root,selection:$selection)
                }
            }
            .navigationBarTitle("팔로워의 리뷰", displayMode: .inline)
        }
    }
}
