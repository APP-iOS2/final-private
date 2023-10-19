//
//  MapSearchView.swift
//  Private
//
//  Created by 최세근 on 10/13/23.
//

import SwiftUI
import NMapsMap
import FirebaseFirestore
import FirebaseStorage

struct LocationView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var locationSearchStore = LocationSearchStore.shared
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var userStore: UserStore
    
    @Binding var coord: NMGLatLng
    @Binding var searchResult: SearchResult
    @Binding var registrationAlert: Bool
    @Binding var newMarkerlat: String
    @Binding var newMarkerlng: String
    
    @State private var createdAt: Double = Date().timeIntervalSince1970
    @State private var myselectedCategory: [String] = []
    @State private var text: String = "" /// 텍스트마스터 내용
    @State private var images: [String] = []
    @State private var selectedImage: [UIImage]?
    
    
    var db = Firestore.firestore()
    var storage = Storage.storage()

    var body: some View {
        VStack {
            Text("지도를 클릭하여 신규장소를 저장할 수 있습니다.")
            PostNaverMap(currentFeedId: $postCoordinator.currentFeedId, showMarkerDetailView: $postCoordinator.showMarkerDetailView, coord: $postCoordinator.coord, tappedLatLng: $postCoordinator.tappedLatLng)
            
        }
        .onAppear {
            //            coordinator.checkIfLocationServicesIsEnabled()
            Coordinator.shared.feedList = feedStore.feedList
//            postCoordinator.makeMarkers()
        }
        //        .onChange(of: coord, perform: { _ in
        //            coordinator.fetchUserLocation()
        //        })
        .alert("신규 장소를 저장합니다.", isPresented: $postCoordinator.newMarkerAlert) {
            TextField("신규 장소 등록", text: $postCoordinator.newMarkerTitle)
                .autocapitalization(.none)
                .textInputAutocapitalization(.none)
            Button("취소") {
                postCoordinator.newMarkerAlert = false
            }
            Button("등록") {
                postCoordinator.newMarkerAlert = false
                postCoordinator.makeMarkers()
                newMarkerlat = locationSearchStore.changeCoordinates(postCoordinator.tappedLatLng.lat,  3) ?? ""
                newMarkerlng = locationSearchStore.changeCoordinates(postCoordinator.tappedLatLng.lng , 4) ?? ""
                print("신규등록 시 \(newMarkerlat), \(newMarkerlng)")
                registrationAlert = true
            }
            //            .task {
            //                await shopStore.getAllShopData()
            //            }
        }
        .overlay(
            TextField("", text: $postCoordinator.newMarkerTitle)
                .opacity(0)
                .frame(width: 0, height: 0)
        )
        .alert("신규 장소 저장완료\n홈에서 확인 가능", isPresented: $registrationAlert) {
            Button("완료") {
                dismiss()
                print("registrationAlert 마지막상태: \(registrationAlert)")
                print("newMarkerTitle 저장 된 이름: \(postCoordinator.newMarkerTitle)")

            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(coord: .constant(NMGLatLng(lat: 36.444, lng: 127.332)), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")), registrationAlert: .constant(false), newMarkerlat: .constant(""), newMarkerlng: .constant(""))
            .environmentObject(UserStore())
            .environmentObject(FeedStore())
            .environmentObject(ShopStore())
        
    }
}
