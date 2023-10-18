//
//  MapMainView.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI
import UIKit
import NMapsMap

struct MapMainView: View {
    
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    @StateObject var coordinator: Coordinator = Coordinator.shared
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var feedStore: FeedStore
    @State private var coord: NMGLatLng = NMGLatLng(lat: 0.0, lng: 0.0)
    var body: some View {
        VStack {
            Text("Print를 위해 잠시 넣어둠 Tapped LatLng: \(coordinator.tappedLatLng?.description ?? "N/A")")
            NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView,
                     markerTitle: $coordinator.newMarkerTitle,
                     markerTitleEdit: $coordinator.newMarkerAlert, coord: $coordinator.coord)

        }
        .onAppear {
            coordinator.checkIfLocationServicesIsEnabled()
            Coordinator.shared.feedStore.feedList = feedStore.feedList
            coordinator.makeMarkers()
        }
//        .onChange(of: coord, perform: { _ in
//                coordinator.fetchUserLocation()
//        })
        .onChange(of: coord, perform: { _ in
                coordinator.fetchUserLocation()
        })
 
        .sheet(isPresented: $coordinator.showMarkerDetailView) {
            MapFeedSheetView()
                .presentationDetents([.height(400), .large])
        }
        
            //            .task {
            //                await shopStore.getAllShopData()
            //            }
        .overlay(
            TextField("", text: $coordinator.newMarkerTitle)
                .opacity(0)
                .frame(width: 0, height: 0)
        )    }
    
}

//struct MapMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapMainView()
//            .environmentObject(ShopStore())
//            .environmentObject(FeedStore())
//    }
//}
