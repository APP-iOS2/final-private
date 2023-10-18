//
//  MapSearchView.swift
//  Private
//
//  Created by 최세근 on 10/13/23.
//

import SwiftUI
import NMapsMap
import FirebaseFirestore

struct LocationView: View {
    
    @ObservedObject private var locationSearchStore = LocationSearchStore.shared
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var userStore: UserStore
    
    @Binding var coord: NMGLatLng
    @Binding var searchResult: SearchResult
    
    @State private var createdAt: Double = Date().timeIntervalSince1970
    @State private var myselectedCategory: [String] = []
    @State private var text: String = "" /// 텍스트마스터 내용
    @State private var images: [String] = []
    
    var db = Firestore.firestore()
    
    var body: some View {
        VStack {
            Text("지도를 클릭하여 신규장소를 저장할 수 있습니다.")
            NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView,
                     markerTitle: $coordinator.newMarkerTitle,
                     markerTitleEdit: $coordinator.newMarkerAlert, coord: $coordinator.coord)
            
        }
        .onAppear {
            //            coordinator.checkIfLocationServicesIsEnabled()
            Coordinator.shared.feedStore.feedList = feedStore.feedList
            coordinator.makeMarkers()
        }
        //        .onChange(of: coord, perform: { _ in
        //            coordinator.fetchUserLocation()
        //        })
        .alert("신규 장소를 저장합니다.", isPresented: $coordinator.newMarkerAlert) {
            TextField("신규 장소 등록", text: $coordinator.newMarkerTitle)
                .autocapitalization(.none)
                .textInputAutocapitalization(.none)
            Button("취소") {
                coordinator.newMarkerAlert = false
            }
            Button("등록") {
                coordinator.newMarkerAlert = false
                coordinator.makeMarkers()
//                creatFeed()
            }
            //            .task {
            //                await shopStore.getAllShopData()
            //            }
        }
        .overlay(
            TextField("", text: $coordinator.newMarkerTitle)
                .opacity(0)
                .frame(width: 0, height: 0)
        )    }
    func creatFeed() {
        let feed = MyFeed(writerNickname: userStore.user.nickname,
                          writerName: userStore.user.name,
                          writerProfileImage: userStore.user.profileImageURL,
                          images: images,
                          contents: text,
                          createdAt: createdAt,
                          title: coordinator.newMarkerTitle,
                          category: myselectedCategory,
                          address: searchResult.address,
                          roadAddress: searchResult.roadAddress,
                          mapx: searchResult.mapx,
                          mapy: searchResult.mapy
        )
        do {
            try db.collection("User").document(userStore.user.email).collection("MyFeed").document(feed.id) .setData(from: feed)
        } catch {
            print("Error saving feed: \(error)")
        }
        do {
            try db.collection("Feed").document(feed.id).setData(from: feed)
        } catch {
            print("Error saving feed: \(error)")
        }
    }
    
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(coord: .constant(NMGLatLng(lat: 36.444, lng: 127.332)), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")))
            .environmentObject(UserStore())
            .environmentObject(FeedStore())
            .environmentObject(ShopStore())
        
    }
}
