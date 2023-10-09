//
//  ShopDetailView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI
import Kingfisher

// Todo: - UI 관련
/// - Picker 지우고 라이브러리로 변경

enum ShopDetailCategory: String, CaseIterable {
    case shopInfo = "가게 정보"
    case shopMenu = "메뉴"
    case shopCurrentReview = "최근 리뷰"
}

struct ShopDetailView: View {
    
    @State var selectedShopDetailCategory: ShopDetailCategory = .shopInfo
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State var isReservationPresented: Bool = false
    @State private var offsetY: CGFloat = CGFloat.zero
    
    let dummyShop = ShopStore.shop
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
//                LazyVStack(pinnedViews: .sectionHeaders) {
                ZStack(alignment: .topLeading) {
                    Section {
                        ShopDetailBodyView(shopDetailName: dummyShop.name, shopDetailCategoryName: dummyShop.category.categoryName, shopDetailAddress: dummyShop.address, shopDetailAddressDetail: dummyShop.addressDetail, selectedShopDetailCategory: $selectedShopDetailCategory)
                            .padding(.top, CGFloat.screenHeight * 0.2)
                    } header: {
                        ShopDetailHeaderView(shopDetailImageURL: dummyShop.shopImageURL)
                    }
                }
            }
            
            ShopDetailFooterView(isReservationPresented: $isReservationPresented)
        }
    }
    
    struct ShopDetailView_Previews: PreviewProvider {
        static var previews: some View {
            ShopDetailView(root: .constant(true), selection: .constant(4))
                .environmentObject(ShopStore())
                .environmentObject(ReservationStore())
        }
    }
    
    struct ShopDetailHeaderView: View {
        
        let shopDetailImageURL: String
        
        var body: some View {
            KFImage(URL(string: shopDetailImageURL)!)
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
        
        let shopDetailName: String
        let shopDetailCategoryName: String
        let shopDetailAddress: String
        let shopDetailAddressDetail: String
        
        @Binding var selectedShopDetailCategory: ShopDetailCategory
        @State var isExpanded: Bool = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        Spacer()
                            .frame(height: 10)
                        
                        HStack(spacing: 10) {
                            Text(shopDetailName)
                                .foregroundColor(.chatTextColor)
                                .font(Font.pretendardBold28)
                            
                            Divider()
                                .frame(height: 25)
                            
                            Text(shopDetailCategoryName)
                                .font(Font.pretendardMedium18)
                        }
                        
                        Section {
                            if isExpanded {
                                HStack(spacing: 5) {
                                    Text(shopDetailAddressDetail)
                                        .font(Font.pretendardRegular14)
                                    
                                    Image(systemName: "doc.on.doc")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15, height: 15)
                                }
                            }
                        } header: {
                            HStack(spacing: 2) {
                                Text(shopDetailAddress)
                                    .font(Font.pretendardMedium18)
                                
                                Image(systemName: isExpanded ? "chevron.down": "chevron.right")
                            }
                            .onTapGesture {
                                isExpanded.toggle()
                            }
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
                
                Picker(selection: $selectedShopDetailCategory, label: Text(selectedShopDetailCategory.rawValue).font(Font.pretendardRegular16)) {
                    ForEach(ShopDetailCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .font(Font.pretendardRegular16)
                            .foregroundColor(.chatTextColor)
                    }
                }
                .pickerStyle(.segmented)
                .padding(10)
                .padding(.bottom, 5)
                
                ScrollView {
                    switch selectedShopDetailCategory {
                    case .shopInfo:
                        ShopwDetailInfoView()
                    case .shopMenu:
                        ShopDetailMenuView()
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
    }
    
    struct ShopDetailFooterView: View {
        
        @Environment(\.colorScheme) var colorScheme
        @Binding var isReservationPresented: Bool
        
        var body: some View {
            HStack(spacing: 10) {
                VStack(spacing: 2) {
                    Image(systemName: "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                    Text("\(999)+") // bookmarks count
                        .font(Font.pretendardBold14)
                }
                
                Button {
                    isReservationPresented.toggle()
                } label: {
                    Text("예약하기")
                        .frame(maxWidth: .infinity)
                }
                .frame(height: CGFloat.screenHeight * 0.05)
                .frame(maxWidth: .infinity)
                .tint(.primary)
                .background(Color("AccentColor"))
                .cornerRadius(12)
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
            .sheet(isPresented: $isReservationPresented) {
                ReservationView(isReservationPresented: $isReservationPresented, shopData: ShopStore.shop)
            }
        }
    }
}
