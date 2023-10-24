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
    
    @State var selectedShopCategory: Category = .general
    @State var selectedShopListSortCriterion: ShopListSortCriterion = .basic
    
    @State var isShowingFilteringView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Text("\(selectedShopCategory.categoryName), \(selectedShopListSortCriterion.rawValue)")
                    .font(.pretendardBold20)
                    .foregroundColor(.privateColor)
                
                Spacer()
                
                Button {
                    isShowingFilteringView.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                        .foregroundColor(.subGrayColor)
                }
            }
            .frame(height: 40)
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(shopStore.shopList.filter({ shop in
                    if selectedShopCategory == Category.general {
                        return true
                    } else {
                        return shop.category == selectedShopCategory
                    }
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
                    ShopListCell(shop: shop)
                            .padding(.vertical, 5)
                            .foregroundColor(colorScheme == ColorScheme.dark ? Color.white : Color.black)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingFilteringView) {
            ShopListFilteringView(originalShopCategory: selectedShopCategory, originalShopListSortCriterion: selectedShopListSortCriterion, selectedShopCategory: $selectedShopCategory, selectedShopListSortCriterion: $selectedShopListSortCriterion, isShowingFilteringView: $isShowingFilteringView)
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

struct ShopListView_Previews: PreviewProvider {
    static var previews: some View {
        ShopListView(root: .constant(true), selection: .constant(4))
            .environmentObject(ShopStore())
    }
}

struct ShopListCell: View {
    
    @EnvironmentObject var userStore: UserStore
    
    @State var isShowingDetailView: Bool = false
    
    @State var shop: Shop
    
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
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .center, spacing: 7) {
                            Text("\(shop.name)")
                                .font(Font.pretendardBold18)
                            
                            Divider()
                                .frame(height: 20)
                            
                            Text("\(shop.category.categoryName)")
                                .font(Font.pretendardMedium16)
                        }
                        
                        Text("\(shop.address)")
                            .font(Font.pretendardRegular14)
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $isShowingDetailView) {
                ShopDetailView(shop: shop)
            }
        }
    }
}

struct ShopListFilteringView: View {
    
    @State var originalShopCategory: Category
    @State var originalShopListSortCriterion: ShopListSortCriterion
    
    @Binding var selectedShopCategory: Category
    @Binding var selectedShopListSortCriterion: ShopListSortCriterion
    
    @Binding var isShowingFilteringView: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Section {
                    FlowLayout(mode: .scrollable, items: Category.allCases, itemSpacing: 5) { data in
                        Button {
                            selectedShopCategory = data
                        } label: {
                            Text(data.categoryName)
                                .font(Font.pretendardBold14)
                                .foregroundColor(selectedShopCategory == data ? Color.black : Color.white)
                                .padding(10)
                        }
                        .background(selectedShopCategory == data ? Color.privateColor : Color("SubGrayColor"))
                        .cornerRadius(12)
                    }
                } header: {
                    Text("카테고리")
                        .font(Font.pretendardBold24)
                        .padding(.horizontal, 10)
                }
                
                Divider()
                    .padding(.vertical, 10)
                
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
                        .background(selectedShopListSortCriterion == data ? Color.privateColor : Color("SubGrayColor"))
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
                        isShowingFilteringView.toggle()
                    } label: {
                        Text("취소")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingFilteringView.toggle()
                    } label: {
                        Text("적용")
                    }
                }
            }
        }
    }
}
