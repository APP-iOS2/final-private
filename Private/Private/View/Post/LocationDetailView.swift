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
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    
    var body: some View {
        VStack {
            // 이 뷰에는 마커가 찍히지 않는 맵이 들어가야함(중앙 마커는 존재)
            Text("해당 장소로 이동")
            NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView,
                     markerTitle: $coordinator.newMarkerTitle,
                     markerTitleEdit: $coordinator.newMarkerAlert, coord: $coordinator.coord)
            
        }
        .onAppear {
            Coordinator.shared.feedList = feedStore.feedList
            coordinator.makeMarkers()
        }
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(coord: .constant(NMGLatLng(lat: 36.444, lng: 127.332)), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")))
            .environmentObject(UserStore())
            .environmentObject(FeedStore())
            .environmentObject(ShopStore())
        
    }
}
