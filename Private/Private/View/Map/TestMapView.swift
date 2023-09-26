//
//  testMapView.swift
//  Private
//
//  Created by Lyla on 2023/09/23.
//

import SwiftUI
import NMapsMap

struct TestMapView: View {
    @EnvironmentObject var userStore: UserStore
    
    //@StateObject var coordinator: Coordinator = Coordinator.shared
    @State private var coord: NMGLatLng = NMGLatLng(lat: 36.444, lng: 127.332)
    var body: some View {
        ZStack {
            NaverMap(coord: $coord)
                .ignoresSafeArea(.all, edges: .top)
        }
        .zIndex(1)
        .onAppear{
            Coordinator.shared.checkIfLocationServicesIsEnabled()
            Coordinator.shared.moveCameraPosition()
            Coordinator.shared.makeMarkers()
            userStore.addUser(User(
                name: "맛집탐방러",
                nickname: "Private",
                phoneNumber: "010-0000-0000",
                profileImageURL: "https://discord.com/channels/1087563203686445056/1153285554646036550/1154579593819344928",
                follower: [],
                following: [],
                myFeed: [],
                savedFeed: [],
                bookmark: [
                    Shop(
                    name: "강남 맛집",
                    category: Category.koreanFood,
                    coord: NMGLatLng(lat: 36.444, lng: 127.332),
                    address: "서울시 강남구",
                    addressDetail: "7번 출구 어딘가",
                    shopTelNumber: "010-1234-5678",
                    shopInfo: "미슐랭 맛집",
                    shopImageURL: "",
                    shopItems: [],
                    numberOfBookmark: 0
                ), Shop(
                    name: "강남 맛집2",
                    category: Category.koreanFood,
                    coord: NMGLatLng(lat: 36.4445, lng: 127.331),
                    address: "서울시 강남구",
                    addressDetail: "7번 출구 어딘가",
                    shopTelNumber: "010-1234-5678",
                    shopInfo: "미슐랭 맛집",
                    shopImageURL: "",
                    shopItems: [],
                    numberOfBookmark: 0
                ), Shop(
                    name: "강남 맛집3",
                    category: Category.koreanFood,
                    coord: NMGLatLng(lat: 36.4442, lng: 127.339),
                    address: "서울시 강남구",
                    addressDetail: "7번 출구 어딘가",
                    shopTelNumber: "010-1234-5678",
                    shopInfo: "미슐랭 맛집",
                    shopImageURL: "",
                    shopItems: [],
                    numberOfBookmark: 0
                )
                ],
                chattingRoom: [],
                myReservation: []))
        }
    }
    
}

struct TestMapView_Previews: PreviewProvider {
    static var previews: some View {
        TestMapView()
    }
}
