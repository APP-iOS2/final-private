//
//  ReviewSheetView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//
import SwiftUI

struct MapReviewSheetView: View {
    
    @EnvironmentObject var feedStore: FeedStore
    
    var body: some View {
        NavigationStack {
            List(feedStore.feedList) { feed in
                MapReviewRowView(feed: feed)
            }
            .navigationTitle("팔로워의 리뷰")
            .listStyle(.plain)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct MapReviewSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapReviewSheetView()
    }
}
