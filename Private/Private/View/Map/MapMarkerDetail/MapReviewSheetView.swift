//
//  ReviewSheetView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//
import SwiftUI
import NMapsMap
struct MapReviewSheetView: View {
    var feeds: [Feed] = dummyFeeds
    
    var body: some View {
        NavigationView {
            List(feeds, id: \.id) { feed in
                MapReviewRowView(feed: feed)
            }
            .navigationBarTitle("팔로워의 리뷰", displayMode: .inline)
        }
    }
}
struct ReviewSheetView_Previews: PreviewProvider {
    static var previews: some View {
        MapReviewSheetView()
            .previewDevice("iPhone 14")
    }
}
