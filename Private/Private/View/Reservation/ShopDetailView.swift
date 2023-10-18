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

enum ShopDetailCategory: String, CaseIterable {
    case shopInfo = "가게 정보"
    case shopMenu = "메뉴"
    case shopCurrentReview = "최근 리뷰"
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
        NavigationStack {
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
            
            ShopDetailFooterView(isReservationPresented: $isReservationPresented, shopViewModel: shopViewModel)
        }
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
    
    @State var isExpanded: Bool = false
    @Binding var selectedShopDetailCategory: ShopDetailCategory
    
    @State var shopData: Shop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Spacer()
                        .frame(height: 10)
                    
                    HStack(spacing: 10) {
                        Text(shopData.name)
                            .foregroundColor(.chatTextColor)
                            .font(.pretendardBold28)
                        
                        Divider()
                            .frame(height: 25)
                        
                        Text(shopData.category.categoryName)
                            .font(.pretendardMedium18)
                    }
                    
                    HStack(alignment: .center, spacing: 5) {
                        Text(shopData.address + " " + shopData.addressDetail)
                            .font(.pretendardMedium16)
                        
                        Button {
                            copyToClipboard(shopData.address + " " + shopData.addressDetail)
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)

                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 10)
                }
                
                Spacer()
                
                Menu {
                    Text("카카오톡으로 공유하기")
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
                .padding(.vertical, 20)
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
                    ShopwDetailCurrentReviewView()
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
    
    func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

struct ShopDetailFooterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject var shopStore: ShopStore

    @Binding var isReservationPresented: Bool
    
    @ObservedObject var shopViewModel: ShopViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 2) {
                Button {
                    if shopViewModel.shop.bookmarks.contains(userStore.user.email) {
                        shopViewModel.shop.bookmarks.removeAll { userID in
                            return userID == userStore.user.email
                        }
                    } else {
                        shopViewModel.shop.bookmarks.append(userStore.user.email)
                    }
                    shopViewModel.updateShop(shopID: shopViewModel.shop.id)
                    shopViewModel.fetchShop(shopID: shopViewModel.shop.id)
                } label: {
                    Image(systemName: shopViewModel.shop.bookmarks.contains(userStore.user.email) ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
                
                Text("\(shopViewModel.shop.bookmarks.count)")
                    .font(.pretendardSemiBold12)
            }
            
            Button {
                isReservationPresented.toggle()
            } label: {
                Text("예약하기")
                    .frame(maxWidth: .infinity)
            }
            .frame(height: CGFloat.screenHeight * 0.065)
            .frame(maxWidth: .infinity)
            .tint(.primary)
            .background(Color("AccentColor"))
            .cornerRadius(12)
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
            ReservationView(isReservationPresented: $isReservationPresented, shopData: viewModel.shop)
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
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(shopID)
        
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
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(shopID)
        
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
        let db = Firestore.firestore()
        let shopRef = db.collection("Shop").document(shopID)
        
        shopRef.getDocument { snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let shopData = snapshot?.data(), let shop = Shop(documentData: shopData) {
                self.shop = shop
            }
        }
    }
}
