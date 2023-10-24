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
    
    @Binding var searchResult: SearchResult
    @Binding var registrationAlert: Bool
    @Binding var newMarkerlat: String
    @Binding var newMarkerlng: String
    @Binding var isSearchedLocation: Bool

    @State private var createdAt: Double = Date().timeIntervalSince1970
    @State private var myselectedCategory: [String] = []
    @State private var text: String = ""
    @State private var images: [String] = []
    @State private var selectedImage: [UIImage]?
    
    var db = Firestore.firestore()
    var storage = Storage.storage()

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("지도를 탭하여 원하는 장소를 선택할 수 있습니다.")
                        .font(.pretendardRegular14)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.darkGrayColor)
                        .cornerRadius(30)
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.pretendardBold24)
                            .foregroundStyle(.black)
                            .padding(.leading, 10)
                    }
                }
                Spacer()
            }
            .zIndex(1)
            .padding(.top, 20)
            
            PostNaverMap(currentFeedId: $postCoordinator.currentFeedId, showMarkerDetailView: $postCoordinator.showMarkerDetailView, showMyMarkerDetailView: $postCoordinator.showMyMarkerDetailView, coord: $postCoordinator.coord, tappedLatLng: $postCoordinator.tappedLatLng)
        }
        .onAppear {
            postCoordinator.checkIfLocationServicesIsEnabled()
            postCoordinator.removeAllMarkers()
            postCoordinator.makeNewLocationMarker()
            postCoordinator.newLocalmoveCameraPosition()
        }
        .alert("신규 장소를 저장합니다.", isPresented: $postCoordinator.newMarkerAlert) {
            TextField("신규 장소 등록", text: $postCoordinator.newMarkerTitle)
                .autocapitalization(.none)
                .textInputAutocapitalization(.none)
            Button("취소") {
                postCoordinator.newMarkerAlert = false
            } .foregroundStyle(.red)
            Button("등록") {
                postCoordinator.newMarkerAlert = false
                newMarkerlat = locationSearchStore.changeCoordinates(postCoordinator.tappedLatLng.lat,  3) ?? ""
                newMarkerlng = locationSearchStore.changeCoordinates(postCoordinator.tappedLatLng.lng , 4) ?? ""
                searchResult.title = postCoordinator.newMarkerTitle
                isSearchedLocation = false
                print("신규등록 시 \(newMarkerlat), \(newMarkerlng)")
                print("신규등록 시 \(postCoordinator.newMarkerTitle)")

            }
        }
//        .overlay(
//            TextField("", text: $postCoordinator.newMarkerTitle)
//                .opacity(0)
//                .frame(width: 0, height: 0)
//        )
//        .alert("신규 장소 저장완료\n홈에서 확인 가능", isPresented: $registrationAlert) {
//            Button("완료") {
////                registrationAlert = false
//                dismiss()
//                print("registrationAlert 마지막상태: \(registrationAlert)")
//                print("newMarkerTitle 저장 된 이름: \(postCoordinator.newMarkerTitle)")
//
//            }
//        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")), registrationAlert: .constant(false), newMarkerlat: .constant(""), newMarkerlng: .constant(""), isSearchedLocation: .constant(false))
            .environmentObject(UserStore())
            .environmentObject(FeedStore())
            .environmentObject(ShopStore())
        
    }
}
