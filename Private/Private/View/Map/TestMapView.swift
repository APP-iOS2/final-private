//
//  testMapView.swift
//  Private
//
//  Created by Lyla on 2023/09/23.
//

import SwiftUI
import NMapsMap

struct TestMapView: View {
    //@EnvironmentObject var userDataStore: UserStore = UserStore()
    @State private var isSheetPresented: Bool = false
    //@StateObject var coordinator: Coordinator = Coordinator.shared
    @State private var coord: NMGLatLng = NMGLatLng(lat: 36.444, lng: 127.332)
    var body: some View {
        ZStack {
            NaverMap(coord: $coord ,isSheetPresented: $isSheetPresented)
                .ignoresSafeArea(.all, edges: .top)
        }
        .zIndex(1)
        .onAppear{
            Coordinator.shared.checkIfLocationServicesIsEnabled()
            //Coordinator.shared.userDataStore.user = userDataStore.user
            Coordinator.shared.moveCameraPosition()
            Coordinator.shared.makeMarkers()
        }
        .sheet(isPresented: $isSheetPresented) {
            MapReviewSheetView()
                .presentationDetents([.height(.screenHeight - 500)])
        }
    }
}
struct TestMapView_Previews: PreviewProvider {
    static var previews: some View {
        TestMapView()
       
    }
}

//비행기 버튼 누르면  채팅방이없으면 새로생기고, 키보드 뜨면서 메세지 보내기  하기 ...!
