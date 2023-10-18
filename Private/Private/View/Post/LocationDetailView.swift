//
//  LocationDetailView.swift
//  Private
//
//  Created by 최세근 on 10/17/23.
//

import SwiftUI
import NMapsMap
import FirebaseFirestore

struct LocationDetailView: View {
    @EnvironmentObject var feedStore: FeedStore
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared
    
    var body: some View {
        VStack {
            // 이 뷰에는 마커가 찍히지 않는 맵이 들어가야함(중앙 마커는 존재)
            Text("해당 장소로 이동")
            PostNaverMap(currentFeedId: $postCoordinator.currentFeedId, showMarkerDetailView: $postCoordinator.showMarkerDetailView,
                     markerTitle: $postCoordinator.newMarkerTitle,
                     markerTitleEdit: $postCoordinator.newMarkerAlert, coord: $postCoordinator.coord)
            
        }
        .onAppear {
            Coordinator.shared.feedList = feedStore.feedList
            postCoordinator.makeMarkers()
        }
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView()
            .environmentObject(UserStore())
            .environmentObject(FeedStore())
            .environmentObject(ShopStore())
        
    }
}
