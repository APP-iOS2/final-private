//
//  NaverMap.swift
//  Private
//
//  Created by Lyla on 2023/09/22.
//

import SwiftUI
import NMapsMap
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct NaverMap: UIViewRepresentable {
    
    @EnvironmentObject var userDataStore: UserStore
    
    // test
    @Binding var coord: NMGLatLng
    
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
    init(coord: Binding<NMGLatLng>) {
        self._coord = coord
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        
    }
}

final class Coordinator: NSObject, ObservableObject,NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    
    static let shared = Coordinator()
    
    let view = NMFNaverMapView(frame: .zero)
    
    var userDataStore: UserStore = UserStore()
    
    var markers: [NMFMarker] = []
    var bookMarkedMarkers: [NMFMarker] = []
    var locationManager: CLLocationManager?
    
    @Published var currentShopId: String = "보리마루"
    @Published var isBookMarkTapped: Bool = false
    @Published var showMarkerDetailView: Bool = false
    @Published var coord: NMGLatLng = NMGLatLng(lat: 36.444, lng: 127.332)
    @Published var userLocation: (Double, Double) = (0.0, 0.0)
    
    private override init() {
        super.init()
        
        view.showZoomControls = true
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        // MARK: - 줌 레벨 제한
        view.mapView.zoomLevel = 15 // 기본 카메라 줌 레벨
        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        // MARK: - 현 위치 추적 버튼
        view.showLocationButton = true
        view.showCompass = false
        
        // MARK: - NMFMapViewCameraDelegate를 상속 받은 Coordinator 클래스 넘겨주기
        view.mapView.addCameraDelegate(delegate: self)
        
        // MARK: - 지도 터치 시 발생하는 touchDelegate
        view.mapView.touchDelegate = self
    }
    
    deinit {
        print("Coordinator deinit!")
    }
    
    func checkIfLocationServicesIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
                    self.checkLocationAuthorization()
                }
            } else {
                print("Show an alert letting them know this is off and to go turn i on.")
            }
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go into setting to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Success")
            //현재위치로 좌표 설정
            coord = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0.0, lng: locationManager.location?.coordinate.longitude ?? 0.0)
            print("LocationManager-coord: \(coord)")
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            print("LocationManager-userLocation: \(userLocation)")
            fetchUserLocation()
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    // NaverMapView를 반환
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    func makeMarkers() {
        for shopMarker in UserStore.user.bookmark {
            let marker = NMFMarker()
            
            marker.position = shopMarker.coord
            marker.captionRequestedWidth = 100 // 마커 캡션 너비 지정
            marker.captionText = shopMarker.name
            marker.captionMinZoom = 10
            marker.captionMaxZoom = 17
            marker.iconImage = NMFOverlayImage(name: "placeholder")
            marker.width = CGFloat(40)
            marker.height = CGFloat(40)
            
            markers.append(marker)
        }
        
        for marker in markers {
            marker.mapView = view.mapView
        }
        markerTapped()
    }
    
    //    func makeBookMarkedMarkers() {
    //        for bookMarkedShop in filterUserShopData() {
    //            let marker = NMFMarker()
    //            marker.position = NMGLatLng(lat: bookMarkedShop.location.latitude, lng: bookMarkedShop.location.longitude)
    //            marker.captionRequestedWidth = 100 // 마커 캡션 너비 지정
    //            marker.captionText = bookMarkedShop.shopName
    //            marker.captionMinZoom = 10
    //            marker.captionMaxZoom = 17
    //            marker.iconImage = NMFOverlayImage(name: bookMarkedShop.isRegister ? "MapMarker.fill" : "MapMarker")
    //            marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
    //            marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
    //
    //            bookMarkedMarkers.append(marker)
    //        }
    //
    //        for marker in bookMarkedMarkers {
    //            marker.mapView = view.mapView
    //        }
    //        markerTapped()
    //    }
    
    func fetchUserLocation() {
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0))
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 1
            
            // MARK: - 현재 위치 좌표 overlay 마커 표시
            let locationOverlay = view.mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0)
            locationOverlay.hidden = false
            
            // MARK: - 내 주변 5km 반경 overlay 표시
            let circle = NMFCircleOverlay()
            circle.center = NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0)
            circle.radius = 5000
            circle.mapView = nil
            
            view.mapView.moveCamera(cameraUpdate)
        }
    }
    
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
    
    // MARK: - 카메라 이동
    func moveCameraPosition() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        Coordinator.shared.view.mapView.moveCamera(cameraUpdate)
    }
    
    // MARK: - 지도 터치에 이용되는 Delegate
    /// 지도 터치 시 MarkerDetailView 창 닫기
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("Map Tapped")
        showMarkerDetailView = false
    }
    
}
