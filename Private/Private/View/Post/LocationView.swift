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

    @State private var createdAt: Double = Date().timeIntervalSince1970
    @State private var myselectedCategory: [String] = []
    @State private var text: String = "" /// 텍스트마스터 내용
    @State private var images: [String] = []
    @State private var selectedImage: [UIImage]?
    @State private var lat: String = ""
    @State private var lng: String = ""
    
    var db = Firestore.firestore()
    var storage = Storage.storage()

    var body: some View {
        VStack {
            Text("지도를 클릭하여 신규장소를 저장할 수 있습니다.")
            PostNaverMap(currentFeedId: $postCoordinator.currentFeedId, showMarkerDetailView: $postCoordinator.showMarkerDetailView,
                         markerTitle: $postCoordinator.newMarkerTitle,
                         markerTitleEdit: $postCoordinator.newMarkerAlert, coord: $postCoordinator.coord)
            
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
                lat = locationSearchStore.changeCoordinates(postCoordinator.coord.lat, 2) ?? ""
                lng = locationSearchStore.changeCoordinates(postCoordinator.coord.lng, 3) ?? ""
                creatMarkerFeed()
                print("신규등록 시 \(lat), \(lng)")
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
//                registrationAlert = false
                dismiss()
                print("registrationAlert 마지막상태: \(registrationAlert)")
                print("newMarkerTitle 저장 된 이름: \(postCoordinator.newMarkerTitle)")

            }
        }
    }
    func creatMarkerFeed() {
        //        let selectCategory = chipsViewModel.chipArray.filter { $0.isSelected }.map { $0.titleKey }
        
        var feed = MyFeed(writerNickname: userStore.user.nickname,
                          writerName: userStore.user.name,
                          writerProfileImage: userStore.user.profileImageURL,
                          images: images,
                          contents: text,
                          createdAt: createdAt,
                          title: postCoordinator.newMarkerTitle,
                          category: myselectedCategory,
                          address: searchResult.address,
                          roadAddress: searchResult.roadAddress,
                          mapx: lng,
                          mapy: lat
        )
        
        if let selectedImages = selectedImage {
            var imageUrls: [String] = []
            
            for image in selectedImages {
                guard let imageData = image.jpegData(compressionQuality: 0.2) else { continue }
                
                let storageRef = storage.reference().child(UUID().uuidString) //
                
                storageRef.putData(imageData) { _, error in
                    if let error = error {
                        print("Error uploading image: \(error)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        guard let imageUrl = url?.absoluteString else { return }
                        imageUrls.append(imageUrl)
                        
                        if imageUrls.count == selectedImages.count {
                            
                            feed.images = imageUrls
                            
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
                }
            }
        }
    }

}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(coord: .constant(NMGLatLng(lat: 36.444, lng: 127.332)), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")), registrationAlert: .constant(false))
            .environmentObject(UserStore())
            .environmentObject(FeedStore())
            .environmentObject(ShopStore())
        
    }
}
