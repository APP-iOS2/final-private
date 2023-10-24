//
//  ShopDetailView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI
import Kingfisher
import UniformTypeIdentifiers
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import NMapsMap
import PopupView

enum ShopDetailCategory: String, CaseIterable {
    case shopInfo = "가게 정보"
    case shopMenu = "메뉴"
    case shopCurrentReview = "최근 피드"
}

struct ShopDetailView: View {
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject private var userStore: UserStore
    
    @State var selectedShopDetailCategory: ShopDetailCategory = .shopInfo
    @State var isReservationPresented: Bool = false
    
    @ObservedObject var shopViewModel: ShopViewModel
    
    init(shop: Shop) {
        self.shopViewModel = ShopViewModel(shop: shop)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack(alignment: .topLeading) {
                Section {
                    ShopDetailBodyView(selectedShopDetailCategory: $selectedShopDetailCategory, shopData: shopViewModel.shop)
                        .padding(.top, CGFloat.screenHeight * 0.2)
                } header: {
                    ShopDetailHeaderView(shopData: shopViewModel.shop)
                }
            }
        }
        .navigationTitle("\(shopViewModel.shop.name)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .backButtonArrow()
        
        ShopDetailFooterView(isReservationPresented: $isReservationPresented, shopViewModel: shopViewModel)
            .task {
                await shopStore.getAllShopData()
            }
    }
}

struct ShopDetailHeaderView: View {
    
    @State var shopData: Shop
    
    var body: some View {
        KFImage(URL(string: shopData.shopImageURL)!)
            .placeholder({
                ProgressView()
            })
            .resizable()
            .frame(height: CGFloat.screenHeight * 0.2)
            .aspectRatio(contentMode: .fit)
    }
}

struct ShopDetailBodyView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var calendarData: CalendarData
    
    @State var isExpanded: Bool = false
    @State var isAddressCopied: Bool = false
    @State var isMapShowing: Bool = false
    
    @Binding var selectedShopDetailCategory: ShopDetailCategory
    
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    @State var shopData: Shop
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        Spacer()
                            .frame(height: 10)
                        
                        HStack(spacing: 10) {
                            Text(shopData.name)
                                .font(.pretendardBold28)
                            
                            Divider()
                                .frame(height: 25)
                            
                            Text(shopData.category.categoryName)
                                .font(.pretendardMedium18)
                        }
                        
                        HStack(alignment: .center, spacing: 5) {
                            Text(shopData.address + " " + shopData.addressDetail)
                                .font(.pretendardRegular14)
                            
                            Button {
                                copyToClipboard(shopData.name + " " + shopData.address + " " + shopData.addressDetail)
                                self.isAddressCopied = true
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(Color.privateColor)
                                    .frame(width: 15, height: 15)
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 10)
                    }
                    
                    Spacer()
                    
                    Button {
                        isMapShowing.toggle()
                    } label: {
                        Image(systemName: "map")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.privateColor)
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.horizontal, 10)
                
                Picker(selection: $selectedShopDetailCategory, label: Text(selectedShopDetailCategory.rawValue).font(.pretendardRegular16)) {
                    ForEach(ShopDetailCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .font(.pretendardRegular16)
                            .foregroundColor(.chatTextColor)
                    }
                }
                .pickerStyle(.segmented)
                .padding(10)
                
                ScrollView {
                    switch selectedShopDetailCategory {
                    case .shopInfo:
                        ShopDetailInfoView(shopData: shopData)
                    case .shopMenu:
                        ShopDetailMenuView(shopData: shopData)
                    case .shopCurrentReview:
                        ShopwDetailCurrentReviewView(shopData: shopData)
                    }
                }
                .padding([.top, .horizontal], 10)
            }
            
            .frame(maxWidth: .infinity)
            .background(content: {
                ZStack {
                    if colorScheme == ColorScheme.light {
                        Color.white
                    } else {
                        Color.black
                    }
                }
            })
            .cornerRadius(12)
        }
        .popup(isPresented: $isAddressCopied) {
            ToastMessageView(message: "장소가 복사 되었습니다!")
                .onDisappear {
                    isAddressCopied = false
                }
        } customize: {
            $0
                .autohideIn(2)
                .type(.toast)
                .position(.center)
        }
        .sheet(isPresented: $isMapShowing) {
            NavigationStack {
                UIMapView((shopData.coord.lat, shopData.coord.lng))
                    .ignoresSafeArea()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                isMapShowing.toggle()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.pretendardSemiBold16)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
            }
        }
        .cornerRadius(12)
        
        .onAppear {
            calendarData.selectedDate = calendarData.getSelectedDate(shopData: shopData)
            calendarData.currentPage = calendarData.getSelectedDate(shopData: shopData)
            calendarData.titleOfMonth = calendarData.getSelectedDate(shopData: shopData)
        }
    }
}

func copyToClipboard(_ text: String) {
    UIPasteboard.general.string = text
}


struct ShopDetailFooterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject var shopStore: ShopStore

    @Binding var isReservationPresented: Bool
    
    @ObservedObject var shopViewModel: ShopViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            ReservationButton(text: "예약하기") {
                isReservationPresented.toggle()
            }
            .foregroundStyle(Color.black)
        }
        .padding(10)
        .frame(width: CGFloat.screenWidth, height: CGFloat.screenHeight * 0.1)
        .background(content: {
            ZStack {
                if colorScheme == ColorScheme.light {
                    Color.white
                } else {
                    Color.black
                }
            }
        })
        .frame(alignment: .bottom)
        .fullScreenCover(isPresented: $isReservationPresented) {
            ReservationView(shopData: shopViewModel.shop)
        }
        .task {
            shopViewModel.fetchShop(shopID: shopViewModel.shop.id)
        }
        .refreshable {
            shopViewModel.fetchShop(shopID: shopViewModel.shop.id)
        }
    }
}

class ShopViewModel: ObservableObject {
    
    @Published var shop: Shop
    
    init(shop: Shop) {
        self.shop = shop
    }
    
    func fetchBookmarks(shopID: String) {
        let shopRef = shopCollection.document(shopID)
        
        shopRef.getDocument { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            if let document = snapshot, document.exists {
                if let bookmarks = document.data()?["bookmarks"] as? [String] {
                    self.shop.bookmarks = bookmarks
                }
            }
        }
    }
    
    func updateShop(shopID: String) {
        let shopRef = shopCollection.document(shopID)
        
        shopRef.updateData([
//                "address": shop.address,
//                "addressDetail": shop.addressDetail,
                "bookmarks": shop.bookmarks,
//                "breakTimeHours": shop.breakTimeHours,
//                "businessNumber": shop.businessNumber,
//                "category": shop.category.rawValue,
//                "coord": shop.coord,
//                "menu": shop.menu,
//                "name": shop.name,
//                "regularHoliday": shop.regularHoliday,
//                "reservationItems": shop.reservationItems,
//                "shopImageURL": shop.shopImageURL,
//                "shopInfo": shop.shopInfo,
//                "shopOwner": shop.shopOwner,
//                "shopTelNumber": shop.shopTelNumber,
//                "temporaryHoliday": shop.temporaryHoliday,
//                "weeklyBusinessHours": shop.weeklyBusinessHours
            ])
        
        fetchShop(shopID: shopID)
    }
    
    func fetchShop(shopID: String) {
        let shopRef = shopCollection.document(shopID)
        
        shopRef.getDocument { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let shopData = snapshot?.data(), let shop = Shop(documentData: shopData) {
                self.shop = shop
            }
        }
    }
}

struct UIMapView: UIViewRepresentable {
    
    var coord: (Double, Double)
    
    init(_ coord: (Double, Double)) {
        self.coord = coord
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(coord)
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        let marker = NMFMarker()
        let locationOverlay = view.mapView.locationOverlay

        locationOverlay.location = NMGLatLng(lat: coord.0, lng: coord.1)
        locationOverlay.hidden = false
        
        marker.position = NMGLatLng(lat: coord.0, lng: coord.1)
        marker.width = 20
        marker.height = 20
        marker.mapView = view.mapView
        marker.iconImage = NMFOverlayImage(name: "placeholder")

        view.showZoomControls = true
        view.showScaleBar = true

        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        view.mapView.mapType = .basic
        view.mapView.isZoomGestureEnabled = true
        view.mapView.isRotateGestureEnabled = false
        view.mapView.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.addOptionDelegate(delegate: context.coordinator)
        
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coord.0, lng: coord.1))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
        var coord: (Double, Double)
        
        init(_ coord: (Double, Double)) {
            self.coord = coord
        }
        
        func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) { }
        
        func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) { }
        
        func mapViewOptionChanged(_ mapView: NMFMapView) { }
    }
}
