//
//  MapMarkerDetailStore.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//
/*
 // MARK: - Mark 터치 시 이벤트 발생
 func markerTapped() {
     if !isBookMarkTapped {
         print(markers)
         for marker in markers {
             marker.touchHandler = { [self] (overlay) -> Bool in
                 let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng))
                 cameraUpdate.animation = .fly
                 cameraUpdate.animationDuration = 1
                 self.view.mapView.moveCamera(cameraUpdate)
                 self.showMarkerDetailView = true
                 self.currentShopId = marker.captionText
                 print("showMarkerDetailView : \(self.showMarkerDetailView)")
                 //print(currentShopId)
        
                 return true
             }
             marker.mapView = view.mapView
         }
     } else {
         print(bookMarkedMarkers)
         for marker in bookMarkedMarkers {
             marker.touchHandler = { [self] (overlay) -> Bool in
                 let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng))
                 cameraUpdate.animation = .fly
                 cameraUpdate.animationDuration = 1
                 self.view.mapView.moveCamera(cameraUpdate)
                 
                 self.showMarkerDetailView = true
                 self.currentShopId = marker.captionText
                 print("showMarkerDetailView : \(self.showMarkerDetailView)")
                 //print(currentShopId)
                 
                 return true
             }
             marker.mapView = view.mapView
         }
     }
 }
 */
import Foundation

