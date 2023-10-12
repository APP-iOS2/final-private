//
//  MapFeedSheetView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//
import SwiftUI

struct MapFeedSheetView: View {
    
    @EnvironmentObject var feedStore: FeedStore
    
    var body: some View {
        List(feedStore.feedList) { feed in
//            MapMarkerFeedView(feed: feed)
        }
        .listStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct MapFeedSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapFeedSheetView()
    }
}
