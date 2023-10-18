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
    
//    @State var shopData: Shop
    @ObservedObject var shopViewModel: ShopViewModel
        
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                //                LazyVStack(pinnedViews: .sectionHeaders) {
                ZStack(alignment: .topLeading) {
                    Section {
//                        ShopDetailBodyView(selectedShopDetailCategory: $selectedShopDetailCategory, shopData: shopData)
                        ShopDetailBodyView(selectedShopDetailCategory: $selectedShopDetailCategory, shopData: shopViewModel.shop)
                            .padding(.top, CGFloat.screenHeight * 0.2)
                    } header: {
//                        ShopDetailHeaderView(shopData: shopData)
                        ShopDetailHeaderView(shopData: shopViewModel.shop)
                    }
                }
            }
            
//            ShopDetailFooterView(isReservationPresented: $isReservationPresented, isBookmarked: $shopViewModel.shop.b, viewModel: shopViewModel)
//            ShopDetailFooterView(isReservationPresented: $isReservationPresented, isBookmarked: $shopViewModel.isBookmarked, viewModel: shopViewModel)
//            ShopDetailFooterView(isReservationPresented: $isReservationPresented, viewModel: shopViewModel)
            ShopDetailFooterView(isReservationPresented: $isReservationPresented, isBookmarked: shopViewModel.isBookmarked, bookmarkCounts: shopViewModel.bookmarkCounts, viewModel: shopViewModel)
        }
        .task {
            await shopStore.getAllShopData()
        }
    }
}

//struct ShopDetailView_Previews: PreviewProvider {
//    static var previews: some View {
////        ShopDetailView(shopData: ShopStore.shop, shopViewModel: <#ShopViewModel#>)
////        ShopDetailView(shopViewModel: ShopViewModel(shop: <#T##Shop#>, userID: <#T##String#>))
//            .environmentObject(ShopStore())
//            .environmentObject(ReservationStore())
//    }
//}

struct ShopDetailHeaderView: View {
    
    @State var shopData: Shop
    
    var body: some View {
        KFImage(URL(string: shopData.shopImageURL)!)
            .placeholder({
                ProgressView()
            })
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: CGFloat.screenHeight * 0.2)
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
    
//    @State var isBookmarked: Bool = false // 임시!
//    @Binding var isBookmarked: Bool
    @State var isBookmarked: Bool
    @State var bookmarkCounts: Int
    
//    @ObservedObject var viewModel: ShopViewModel
    @State var viewModel: ShopViewModel
    
//    @State var shopData: Shop
    
//    @ObservedObject var shopViewModel: ShopViewModel = ShopViewModel(shop: shopData)
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 2) {
                Button {
                    print("🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️🏳️\(viewModel.isBookmarked)")
                    if viewModel.isBookmarked {
                        viewModel.isBookmarked = false
                        isBookmarked = false
                        viewModel.bookmarkCounts -= 1
                        bookmarkCounts -= 1
//                    if isBookmarked {
//                    if viewModel.checkIfUserBookmarkedShop() {
//                        shopStore.deleteBookmark(document: shopData.id, userID: userStore.user.email)
//                        shopStore.deleteBookmark(document: viewModel.shop.id, userID: userStore.user.email)
                        viewModel.unbookmarkShop()
                    } else {
                        viewModel.isBookmarked = true
                        isBookmarked = true
                        viewModel.bookmarkCounts += 1
                        bookmarkCounts += 1
//                        shopStore.addBookmark(document: shopData.id, userID: userStore.user.email)
//                        shopStore.addBookmark(document: viewModel.shop.id, userID: userStore.user.email)
                        viewModel.bookmarkShop()
                    }

//                    isBookmarked.toggle()
                    
//                    viewModel.checkIfUserBookmarkedShop() ? viewModel.unbookmarkShop() : viewModel.bookmarkShop()
//                    if viewModel.checkIfUserBookmarkedShop() {
//                        print("북마크가 되어 있으므로 언북마크 합니다💛")
//                        viewModel.unbookmarkShop()
//                    } else {
//                        print("북마크가 안🤍되어 있으므로 북마크 합니다🤍")
//                        viewModel.bookmarkShop()
//                    }
                } label: {
//                    Button {
//                        viewModel.tweet.didLike ?? false ? viewModel.unlikeTweet() : viewModel.likeTweet()
//                    } label: {
//                        Image(systemName: viewModel.tweet.didLike ?? false ? "heart.fill" : "heart")
//                            .font(.subheadline)
//                            .foregroundColor(viewModel.tweet.didLike ?? false ? .red : .gray)
//                    }
                    
//                    Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
//                    Image(systemName: viewModel.checkIfUserBookmarkedShop() ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
                
                Text("\(bookmarkCounts)")
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
//            viewModel.fetchShop()
            Task {
                viewModel.fetch()
            }
        }
        .refreshable {
//            viewModel.fetchShop()
            Task {
                viewModel.fetch()
            }
        }
    }
}

class ShopViewModel: ObservableObject {
    
    @Published var shop: Shop
    @Published var isBookmarked: Bool
    @Published var bookmarkCounts: Int
    
    var userID: String
    
    let shopService = ShopStore()
    
    init(shop: Shop, userID: String) {
        self.shop = shop
        self.userID = userID
        self.isBookmarked = shopService.checkBookmark(document: shop.id, userID: userID)
        self.bookmarkCounts = shopService.checkBookmarkCounts(document: shop.id, userID: userID)
//        self.checkIfUserBookmarkedShop()
    }
    
    func bookmarkShop() {
        print("❤️북마크")
        shopService.addBookmark(document: shop.id, userID: userID)
//        self.isBookmarked.toggle()
//        self.bookmarkCounts += 1
//        fetchShop()
        shopService.fetchShop(document: shop.id, userID: userID)
    }
    
    func unbookmarkShop() {
        print("💚언북마크")
        shopService.deleteBookmark(document: shop.id, userID: userID)
//        self.isBookmarked.toggle()
//        self.bookmarkCounts -= 1
//        fetchShop()
        shopService.fetchShop(document: shop.id, userID: userID)
    }
    
    func checkIfUserBookmarkedShop() -> Bool {
        return shopService.checkBookmark(document: shop.id, userID: userID)
    }
    
    func checkBookmarkCount() -> Int {
        return shopService.checkBookmarkCounts(document: shop.id, userID: userID)
//        var resCount = 0
//        shopService.checkBookmarkCount(document: shop.id, userID: userID) { count in
//            print("⭐️\(count)⭐️")
//            resCount = count
//        }
//
//        return resCount
    }
    
    func fetch() {
        shopService.fetchShop(document: shop.id, userID: userID)
    }
}
