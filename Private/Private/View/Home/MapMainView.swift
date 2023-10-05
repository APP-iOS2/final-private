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
    @State var coord: (Double, Double) = (126.9784147, 37.5666805)
    
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    var body: some View {
        VStack {
            NaverMap()
        }
        .onAppear {
            coordinator.makeMarkers()
        }
        
        .sheet(isPresented: $coordinator.showMarkerDetailView) {
            MapReviewSheetView()
                .presentationDetents([.height(400)])
        }
    }
}

struct MapMainView_Previews: PreviewProvider {
    static var previews: some View {
        MapMainView()
    }
}
