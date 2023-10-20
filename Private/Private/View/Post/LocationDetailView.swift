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
    @Binding var searchResult: SearchResult

    var body: some View {
        ZStack {
            VStack {
                Text("\(searchResult.title)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                    .font(.pretendardRegular14)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.darkGrayColor)
                    .cornerRadius(30)
                Spacer()
            }
            .zIndex(1)
            .padding(.top, 20)
            
            PostNaverMap(currentFeedId: $postCoordinator.currentFeedId, showMarkerDetailView: $postCoordinator.showMarkerDetailView, coord: $postCoordinator.coord, tappedLatLng: $postCoordinator.tappedLatLng)
            
        }
        .onAppear {
            Coordinator.shared.feedList = feedStore.feedList
            postCoordinator.removeAllMarkers()
            postCoordinator.makeSearchLocationMarker()
            postCoordinator.moveCameraPosition()
        }
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")))
            .environmentObject(UserStore())
            .environmentObject(FeedStore())
            .environmentObject(ShopStore())
        
    }
}
