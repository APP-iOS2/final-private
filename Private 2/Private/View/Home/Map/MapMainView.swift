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
