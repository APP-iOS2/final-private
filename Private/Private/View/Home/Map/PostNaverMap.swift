//
//  PostNaverMap.swift
//  Private
//
//  Created by 최세근 on 10/18/23.
//

import SwiftUI
import SwiftUI
import NMapsMap
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostNaverMap: UIViewRepresentable {
    
    @EnvironmentObject var userDataStore: UserStore
    @Binding var currentFeedId: String
    @Binding var showMarkerDetailView: Bool
    @Binding var markerTitle: String
    @Binding var markerTitleEdit: Bool
    @Binding var coord: NMGLatLng
    @ObservedObject var postCoordinator = PostCoordinator.shared

    func makeCoordinator() -> PostCoordinator {
        PostCoordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
}

final class PostCoordinator: NSObject, ObservableObject,NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    
    static let shared = PostCoordinator()
    
    let view = NMFNaverMapView(frame: .zero)
    
    var locationSearchStore = LocationSearchStore.shared
    var feedStore: FeedStore = FeedStore()
    var shopStore: ShopStore = ShopStore()
    var userStore: UserStore = UserStore()
    var markers: [NMFMarker] = []
    var locationManager: CLLocationManager?
    var previousMarker: NMFMarker?

    @Published var currentFeedId: String = "보리마루"
    @Published var isBookMarkTapped: Bool = false
    @Published var showMarkerDetailView: Bool = false
    @Published var newMarkerTitle: String = ""
    @Published var newMarkerAlert: Bool = false
    @Published var coord: NMGLatLng = NMGLatLng(lat: 36.444, lng: 127.332)
    
    @Published var userLocation: (Double, Double) = (0.0, 0.0)
    @Published var tappedLatLng: NMGLatLng?

//    let constantCenter = NMGLatLng(lat: 37.572389, lng: 126.9769117)
    
    private override init() {
        super.init()
        
        view.showZoomControls = true
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.mapView.zoomLevel = 15 // 기본 카메라 줌 레벨
        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        
        view.showLocationButton = true
        view.showZoomControls = true // 줌 확대, 축소 버튼 활성화
        view.showCompass = false
        view.showScaleBar = false
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord, zoomTo: 15)
        
        view.mapView.moveCamera(cameraUpdate)
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
            print("위치 정보 접근이 제한되었습니다.")
        case .denied:
            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Success")
            //현재위치로 좌표 설정
            coord = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0.0, lng: locationManager.location?.coordinate.longitude ?? 0.0)
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            fetchUserLocation()
            
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func fetchUserLocation() {
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: 17)
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
    
    // NaverMapView를 반환
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    //MARK: 마커 생성
//    func makeMarkers() {
//        
//        var tempMarkers: [NMFMarker] = []
//        
//        let marker = NMFMarker()
//        //            let lat = locationSearchStore.formatCoordinates(shopMarker.mapy, 2) ?? ""
//        //            let lng = locationSearchStore.formatCoordinates(shopMarker.mapx, 3) ?? ""
//        //            coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
//        coord = NMGLatLng(lat: tappedLatLng?.lat ?? 0, lng: tappedLatLng?.lng ?? 0)
//        marker.position = NMGLatLng(lat: coord.lat, lng: coord.lng)
//        //            marker.position = shopMarker.visitedShop.coord
//        marker.captionRequestedWidth = 100 // 마커 캡션 너비 지정
//        marker.captionText = newMarkerTitle
//        marker.captionMinZoom = 10
//        marker.captionMaxZoom = 17
//        marker.iconImage = NMFOverlayImage(name: "placeholder")
//        marker.width = CGFloat(40)
//        marker.height = CGFloat(40)
//        
//        tempMarkers.append(marker)
//        print("신규장소: \(marker.captionText)")
//        print("마커 생성위치: \(coord.lat), \(coord.lng)")
//        
//        markers = tempMarkers
//        
//        for marker in markers {
//            marker.mapView = view.mapView
//        }
//        markerTapped()
//        //        userStore.saveFeed(MyFeed())
//    }
    
    func removeAllMarkers() {
        for marker in markers {
            marker.mapView = nil // 각 마커를 지도에서 제거
        }
        markers.removeAll() // 배열에서 모든 마커를 제거
    }
    
    // MARK: 해당 장소 이동 시 위치 좌표에 마커
    func makeSearchLocationMarker() {
        
        removeAllMarkers()
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: coord.lat, lng: coord.lng)
        
        marker.captionRequestedWidth = 100 // 마커 캡션 너비 지정
        marker.captionMinZoom = 10
        marker.captionMaxZoom = 17
        marker.captionText = newMarkerTitle.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        marker.iconImage = NMFOverlayImage(name: "placeholder")
        marker.width = CGFloat(40)
        marker.height = CGFloat(40)
        
        // 새로운 마커 mapView에 추가
        marker.mapView = view.mapView
        markers.append(marker)
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
    
    // MARK: - Mark 터치 시 이벤트 발생
//    func markerTapped() {
//        if !isBookMarkTapped {
//            for marker in markers {
//                marker.touchHandler = { [self] (overlay) -> Bool in
//                    
//                    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng))
//                    cameraUpdate.animation = .fly
//                    cameraUpdate.animationDuration = 1
//                    
////                    feedStore.feedList = feedStore.feedList.filter { feed in
////                        let lat = locationSearchStore.formatCoordinates(feed.mapy, 2) ?? ""
////                        let lng = locationSearchStore.formatCoordinates(feed.mapx, 3) ?? ""
////                        let coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
////                        return marker.position.lat == coord.lat && marker.position.lng == coord.lng
////                    }
//                    self.view.mapView.moveCamera(cameraUpdate)
//                    self.currentFeedId = marker.captionText
//                    showMarkerDetailView = true
//                    print("showMarkerDetailView : \(self.showMarkerDetailView)")
//                    print("if에 해당함")
//                    //print(currentShopId)
//                    //                    DispatchQueue.main.async {
//                    //                        print("Before setting isSheetPresentedBinding to true")
//                    //                        self.isSheetPresentedBinding?.wrappedValue = true
//                    //                        print("After setting isSheetPresentedBinding to true")
//                    //                                       }
//                    
//                    return true
//                }
//                marker.mapView = view.mapView
//            }
//        } else {
//            print(markers)
//            for marker in markers {
//                marker.touchHandler = { [self] (overlay) -> Bool in
//                    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: marker.position.lat, lng: marker.position.lng))
//                    cameraUpdate.animation = .fly
//                    cameraUpdate.animationDuration = 1
//                    self.view.mapView.moveCamera(cameraUpdate)
//                    
//                    self.showMarkerDetailView = true
//                    self.currentFeedId = marker.captionText
//                    print("showMarkerDetailView : \(self.showMarkerDetailView)")
//                    //print(currentShopId)
//                    
//                    return true
//                }
//                marker.mapView = view.mapView
//            }
//        }
//    }
    

    // MARK: - 카메라 이동
    func moveCameraPosition() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord, zoomTo: 17)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        view.mapView.moveCamera(cameraUpdate)
    }
    
    // MARK: - 지도 터치에 이용되는 Delegate
    /// 지도에서 터치하면 그 위치에 마커 표시
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        
        removeAllMarkers()
        
        let marker = NMFMarker()
        marker.position = latlng
        marker.iconImage = NMFOverlayImage(name: "placeholder")
        marker.width = CGFloat(40)
        marker.height = CGFloat(40)
        
        // 새로운 마커 mapView에 추가
        marker.mapView = mapView
        
        markers.append(marker)
        
        print("MapView 클릭")
        print("위도: \(latlng.lat), 경도: \(latlng.lng)")
        coord = latlng
        tappedLatLng = latlng
        
        moveCameraPosition()
        
        showMarkerDetailView = false
        
        if showMarkerDetailView == true {
            newMarkerAlert = false
        } else {
            newMarkerAlert = true
        }
    }

    //     func markerTitle(_ mapView: NMFMapView, didTap marker: NMFMarker) -> Bool {
    //
    //         let markerTitleView = MapMarkerDetailView(markerTitle: Binding<String>, isEditing: Binding<Bool>)
    //         view.addSubview(markerTitleView)
    //        return true
    //    }
    
    /// 지도에서 마커를 길게 터치하면 어떠한 행동을 함
    func markerLongPress(_ mapView: NMFMapView, didLongPressOverlay overlay: NMFOverlay) {
        if let marker = overlay as? NMFMarker {
            print("길게 눌러 마커에 접근 (\(marker.position.lat), \(marker.position.lng))")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            coord = NMGLatLng(lat: lat, lng: lng)
            userLocation = (lat, lng)
            fetchUserLocation()
            moveCameraPosition()
        }
    }

}

