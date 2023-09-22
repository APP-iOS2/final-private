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
    
    var body: some View {
        ZStack {
            Button(action: {coord = (129.05562775, 35.1379222)}) {
                Text("Move to Busan")
                    .background(.white)
            }
            .zIndex(1)
            Spacer()
            UIMapView(coord: coord)
                .edgesIgnoringSafeArea(.vertical)
        }
       
    }
}

struct UIMapView: UIViewRepresentable {
    // 받아오는 좌표
    var coord: (Double, Double)
    
    // 지도 뷰 만드는 메서드
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        
        // mapView위에 좌표 추가
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.5670135, lng: 126.9783740)
        marker.mapView = view.mapView
        return view
    }
    
    // 지도 포커스 이동
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
                let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
                cameraUpdate.animation = .fly
                cameraUpdate.animationDuration = 1
                uiView.mapView.moveCamera(cameraUpdate)
    }
}

struct MapMainView_Previews: PreviewProvider {
    static var previews: some View {
        MapMainView()
    }
}
