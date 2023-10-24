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
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State private var coord: NMGLatLng = NMGLatLng(lat: 0.0, lng: 0.0)
    
    var body: some View {
        ZStack {
            VStack {
                if feedStore.feedList.isEmpty {
                    Text("검색 탭으로 이동해 원하는 유저를 팔로우하세요!")
                        .font(.pretendardRegular14)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.darkGrayColor)
                        .cornerRadius(30)
                    NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView,
                     markerTitle: $coordinator.newMarkerTitle,
                     markerTitleEdit: $coordinator.newMarkerAlert, coord: $coordinator.coord)
                } else {
                    NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView,
                     markerTitle: $coordinator.newMarkerTitle,
                     markerTitleEdit: $coordinator.newMarkerAlert, coord: $coordinator.coord)
                }
            }
        }
        .onAppear {
            coordinator.checkIfLocationServicesIsEnabled()
            Coordinator.shared.feedList = feedStore.feedList
            coordinator.makeMarkers()
        }
        
        .sheet(isPresented: $coordinator.showMarkerDetailView) {
            MapFeedSheetView(root: $root, selection: $selection ,feed: feedStore.feedList.filter { $0.id == coordinator.currentFeedId }[0])
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
    }
}

//struct MapMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapMainView()
//            .environmentObject(ShopStore())
//            .environmentObject(FeedStore())
//    }
//}
