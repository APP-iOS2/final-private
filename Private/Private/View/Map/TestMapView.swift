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
            //Coordinator.shared.userDataStore.user = userDataStore.user
            Coordinator.shared.moveCameraPosition()
            Coordinator.shared.makeMarkers()
        }
    }
    
}

struct TestMapView_Previews: PreviewProvider {
    static var previews: some View {
        TestMapView()
    }
}
