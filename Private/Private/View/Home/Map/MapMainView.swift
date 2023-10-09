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
            NaverMap()
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
