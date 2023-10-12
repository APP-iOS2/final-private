//
//  FeedMainView.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI

struct FeedMainView: View {
    
    @EnvironmentObject var feedStore: FeedStore
    
    var body: some View {
        VStack {
            Text("feedStore.feedList.count : \(feedStore.feedList.count)")
            //Circle()
            ScrollView {
                ForEach(feedStore.feedList) { feed in
                    
                    FeedCellView(feed: feed)
                }
            }
        }
    }
}

struct FeedMainView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMainView()
            .environmentObject(FeedStore())
    }
}
