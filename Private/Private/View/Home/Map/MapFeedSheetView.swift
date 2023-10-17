//
//  MapFeedSheetView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//
import SwiftUI

struct MapFeedSheetView: View {
    
    @EnvironmentObject private var feedStore: FeedStore
    
    var body: some View {
        ScrollView {
            let filteredFeedList = feedStore.feedList.filter { feed in
                return true
            }
            
            ForEach(filteredFeedList, id: \.id) { feed in
                FeedCellView(feed: feed, filteredFeedList: filteredFeedList)
            }
        }
    }
}

struct MapFeedSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapFeedSheetView()
    }
}
