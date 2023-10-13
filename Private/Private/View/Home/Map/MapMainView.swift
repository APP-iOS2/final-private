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
    

    var body: some View {
        VStack {
            Text("Print를 위해 잠시 넣어둠 Tapped LatLng: \(coordinator.tappedLatLng?.description ?? "N/A")")
            NaverMap(currentFeedId: $coordinator.currentFeedId, showMarkerDetailView: $coordinator.showMarkerDetailView)
        }
        .onAppear {
            coordinator.checkIfLocationServicesIsEnabled()
            coordinator.makeMarkers()
        }
        .onChange(of: coordinator.tappedLatLng) { newValue in
            locationSearchStore.reverseGeoCoding(lat: String(coordinator.tappedLatLng?.lat ?? 0), long: String(coordinator.tappedLatLng?.lng ?? 0))
        }
        
        .sheet(isPresented: $coordinator.showMarkerDetailView) {
            MapFeedSheetView()
                .presentationDetents([.height(400), .large])
        }
    }
    
}

struct MapMainView_Previews: PreviewProvider {
    static var previews: some View {
        MapMainView()
    }
}
