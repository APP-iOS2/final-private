//
//  MapMainView.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import SwiftUI
import UIKit
import NMapsMap
import PopupView

struct MapMainView: View {
    
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var feedStore: FeedStore
    @State private var coord: NMGLatLng = NMGLatLng(lat: 0.0, lng: 0.0)
    var body: some View {
        VStack {
            NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView, showMyMarkerDetailView: $coordinator.showMyMarkerDetailView,
                     markerTitle: $coordinator.newMarkerTitle,
                     markerTitleEdit: $coordinator.newMarkerAlert, coord: $coordinator.coord)

        }
        .onAppear {
            coordinator.checkIfLocationServicesIsEnabled()
            Coordinator.shared.feedList = feedStore.feedList
            coordinator.makeMarkers()
        }
        
        .sheet(isPresented: $coordinator.showMarkerDetailView) {
            MapFeedSheetView(feed: feedStore.feedList.filter { $0.id == coordinator.currentFeedId }[0])
                .presentationDetents([.height(.screenHeight * 0.55)])
        }
        
        .popup(isPresented: $authStore.welcomeToast) {
            ToastMessageView(message: "Private에 오신걸 환영합니다!")
                .onDisappear {
                    authStore.welcomeToast = false
                }
        } customize: {
            $0
                .autohideIn(2)
                .type(.floater(verticalPadding: 20))
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.clear)
        }
        
//        .overlay(
//            TextField("", text: $coordinator.newMarkerTitle)
//                .opacity(0)
//                .frame(width: 0, height: 0)
//        )
    }
}

//struct MapMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapMainView()
//            .environmentObject(ShopStore())
//            .environmentObject(FeedStore())
//    }
//}
