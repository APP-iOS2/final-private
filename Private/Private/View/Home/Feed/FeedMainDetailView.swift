//
//  FeedMainDetailView.swift
//  Private
//
//  Created by yeon on 10/10/23.
//

import SwiftUI

struct FeedMainDetailView: View {
    
    @EnvironmentObject var feedStore: FeedStore
    
    var body: some View {
        VStack {
            Text("feedStore.feedList.count : \(feedStore.feedList.count)")
            Circle()
        }
//        ScrollView {
//            ForEach(feedStore.feedList) { feed in
//
//                FeedCellView(feed: feed)  // FeedCellView를 호출, feed 데이터를 전달
//            }
//        }
    }
}

struct FeedMainDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMainDetailView()
            .environmentObject(FeedStore())
    }
}
