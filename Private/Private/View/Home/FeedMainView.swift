//
//  FeedMainView.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI

struct FeedMainView: View {
    
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var followStore: FollowStore
    
    var body: some View {
        VStack {
            Text("feedStore.feedList.count : \(feedStore.feedList.count)")
            //Circle()
            if feedStore.feedList.isEmpty {
                // 피드 목록이 비어있는 경우
               
                EmptyFeed(feedType: .noFeed)
                Spacer()
            
            } else if followStore.followingList.isEmpty {
                // 팔로잉 목록이 비어있는 경우 
               
                EmptyFeed(feedType: .noFollowing )
                Spacer()
            }
            else {
                ScrollView {
                    ForEach(feedStore.feedList) { feed in
                        FeedCellView(feed: feed)
                    }
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
