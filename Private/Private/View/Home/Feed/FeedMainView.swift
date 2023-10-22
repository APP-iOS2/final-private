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
    @Binding var root: Bool
    @Binding var selection: Int
    var body: some View {
      
            ScrollView {
                ForEach(feedStore.feedList) { feed in
                    
                    FeedCellView(feed: feed, root:$root,selection:$selection)
                        .padding(.bottom,15)
                }
            }
            .refreshable {
                await feedStore.fetchFeeds()
            }
            .popup(isPresented: $userStore.clickSavedFeedToast) {
                ToastMessageView(message: "피드가 저장 되었습니다!")
                    .onDisappear {
                        userStore.clickSavedFeedToast = false
                    }
            } customize: { 
                $0
                    .autohideIn(1)
                    .type(.floater(verticalPadding: 20))
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.clear)
            }
            .popup(isPresented: $userStore.clickSavedPlaceToast) {
                ToastMessageView(message: "장소가 저장 되었습니다!")
                    .onDisappear {
                        userStore.clickSavedPlaceToast = false
                    }
            } customize: {
                $0
                    .autohideIn(1)
                    .type(.floater(verticalPadding: 20))
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.clear)
            }
            .popup(isPresented: $userStore.clickSavedCancelFeedToast) {
                ToastMessageView(message: "피드 저장이 취소 되었습니다!")
                    .onDisappear {
                        userStore.clickSavedPlaceToast = false
                    }
            } customize: {
                $0
                    .autohideIn(1)
                    .type(.floater(verticalPadding: 20))
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.clear)
            }
            .popup(isPresented: $userStore.clickSavedCancelPlaceToast) {
                ToastMessageView(message: "장소 저장이 취소 되었습니다!")
                    .onDisappear {
                        userStore.clickSavedPlaceToast = false
                    }
            } customize: {
                $0
                    .autohideIn(1)
                    .type(.floater(verticalPadding: 20))
                    .position(.bottom)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.clear)
            }
        
    }
}

struct FeedMainView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMainView(root: .constant(true), selection: .constant(0))
            .environmentObject(FeedStore())
            .environmentObject(UserStore())
    }
}
