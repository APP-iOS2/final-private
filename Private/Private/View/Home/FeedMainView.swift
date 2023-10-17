//
//  FeedMainView.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI

struct FeedMainView: View {
    
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var userStore: UserStore
    var body: some View {
      
            ScrollView {
                ForEach(feedStore.feedList) { feed in
                    
                    FeedCellView(feed: feed)
                        .padding(.bottom,15)
                }
            }
        
    }
}

struct FeedMainView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMainView()
            .environmentObject(FeedStore())
            .environmentObject(UserStore())
    }
}
