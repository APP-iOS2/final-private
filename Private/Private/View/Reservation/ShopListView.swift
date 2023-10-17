//
//  ShopListView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI
import Kingfisher
import SwiftUIFlowLayout
import NMapsMap

enum ShopListSortCriterion: String, CaseIterable {
    case basic = "기본순"
    case bookmark = "북마크순"
    case distance = "거리순"
}

struct ShopListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var userStore: UserStore

    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State var selectedShopCategory: Category = .koreanFood
    @State var selectedShopListSortCriterion: ShopListSortCriterion = .basic
    
    @State var isShowingSheet: Bool = false
    
    @State var currentLocation: String = ""
    
//    init(locationText: String) {
//        _currentLocation = State(initialValue: coordinator.convertLocationToAddress())
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                Text("\(currentLocation)")
                
                Spacer()
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text("\(selectedShopCategory.categoryName), \(selectedShopListSortCriterion.rawValue)")
                    .font(Font.pretendardSemiBold16)
                
                Spacer()
                
                Button {
//                    convertLocationToAddress(location: CLLocation(latitude: coordinator.coord.lat, longitude: coordinator.coord.lng))
                    isShowingSheet.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 10)
            }
            
            ScrollView(.vertical) {
                ForEach(shopStore.shopList.filter({ shop in
                    return shop.category == selectedShopCategory
                }).sorted(by: { shop1, shop2 in
                    switch selectedShopListSortCriterion {
                    case .basic:
                        return shop1.name < shop2.name
                    case .bookmark:
                        return shop1.bookmarks.count > shop2.bookmarks.count
                    case .distance:
                        let coord1 = CLLocation(latitude: shop1.coord.lat, longitude: shop1.coord.lng)
                        let coord2 = CLLocation(latitude: shop2.coord.lat, longitude: shop2.coord.lng)
                        return CLLocation(latitude: coordinator.coord.lat, longitude: coordinator.coord.lng).distance(from: coord1) < CLLocation(latitude: coordinator.coord.lat, longitude: coordinator.coord.lng).distance(from: coord2)
                    }
                }), id: \.self) { shop in
//                        ShopListCell(shop: shop)
                    ShopListCell(shopViewModel: ShopViewModel(shop: shop, userID: userStore.user.id), shop: shop)
                            .padding(.vertical, 5)
                            .foregroundColor(colorScheme == ColorScheme.dark ? Color.white : Color.black)
                }
            }
        }
        .padding(10)
        .sheet(isPresented: $isShowingSheet) {
            ShopListFilterSheetView(originalShopCategory: selectedShopCategory, originalShopListSortCriterion: selectedShopListSortCriterion, selectedShopCategory: $selectedShopCategory, selectedShopListSortCriterion: $selectedShopListSortCriterion, isShowingSheet: $isShowingSheet)
        }
//        .onAppear {
////            currentLocation = convertLocationToAddress(location: CLLocation(latitude: coordinator.coord.lat, longitude: coordinator.coord.lng))
//            currentLocation = coordinator.convertLocationToAddress()
//        }
    }
    
//    func convertLocationToAddress(location: CLLocation) -> String {
//        var locationString: String = ""
//        let geocoder = CLGeocoder()
//
//        geocoder.reverseGeocodeLocation(location) { placemarks, error in
//            if error == nil, let placemark = placemarks?.first {
//                locationString = "\(placemark.country ?? "") \(placemark.locality ?? "") \(placemark.name ?? "")"
//            }
//        }
//
//        return locationString
//    }
}

struct ShopListView_Previews: PreviewProvider {
    static var previews: some View {
        ShopListView(root: .constant(true), selection: .constant(4))
    }
}

struct ShopListCell: View {
    
    @EnvironmentObject var userStore: UserStore
    @ObservedObject var shopViewModel: ShopViewModel
    
    @State var isShowingDetailView: Bool = false
    
    let shop: Shop
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .center, spacing: 10) {
                Button {
                    isShowingDetailView.toggle()
                } label: {
                    KFImage(URL(string: shop.shopImageURL)!)
                        .placeholder({
                            ProgressView()
                        })
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: CGFloat.screenWidth * 0.25, height: CGFloat.screenWidth * 0.25)
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(shop.name)")
                            .font(Font.pretendardBold18)
                        
                        Text("\(shop.address)")
                            .font(Font.pretendardRegular14)
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $isShowingDetailView) {
                ShopDetailView(shopViewModel: ShopViewModel(shop: shop, userID: userStore.user.email))
            }
        }
    }
}

struct ShopListFilterSheetView: View {
    
    @State var originalShopCategory: Category
    @State var originalShopListSortCriterion: ShopListSortCriterion
    
    @Binding var selectedShopCategory: Category
    @Binding var selectedShopListSortCriterion: ShopListSortCriterion
    
    @Binding var isShowingSheet: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Section {
                    FlowLayout(mode: .scrollable, items: Category.allCases, itemSpacing: 5) { data in
                        Button {
                            selectedShopCategory = data
                            print(selectedShopCategory.categoryName)
                        } label: {
                            Text(data.categoryName)
                                .font(Font.pretendardBold14)
                                .foregroundColor(selectedShopCategory == data ? Color.black : Color.white)
                                .padding(10)
                        }
                        .background(selectedShopCategory == data ? Color("AccentColor") : Color("SubGrayColor"))
                        .cornerRadius(12)
                    }
                } header: {
                    Text("카테고리")
                        .font(Font.pretendardBold24)
                        .padding(.horizontal, 10)
                }
                
                Divider()
                
                Section {
                    FlowLayout(mode: .scrollable, items: ShopListSortCriterion.allCases, itemSpacing: 5) { data in
                        Button {
                            selectedShopListSortCriterion = data
                        } label: {
                            Text(data.rawValue)
                                .font(Font.pretendardBold14)
                                .foregroundColor(selectedShopListSortCriterion == data ? Color.black : Color.white)
                                .padding(10)
                        }
                        .background(selectedShopListSortCriterion == data ? Color("AccentColor") : Color("SubGrayColor"))
                        .cornerRadius(12)
                    }
                } header: {
                    Text("정렬 기준")
                        .font(Font.pretendardBold24)
                        .padding(.horizontal, 10)
                }
                
                Spacer()
            }
            .padding(10)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        selectedShopCategory = originalShopCategory
                        selectedShopListSortCriterion = originalShopListSortCriterion
                        isShowingSheet.toggle()
                    } label: {
                        Text("취소")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Text("적용")
                    }
                }
            }
        }
    }
}
