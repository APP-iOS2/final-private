//
//  ShopDetailView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI

// Todo: - UI 관련
/// - 헤더뷰 height(CGFloat.screenHeight * 0.1) 수정
/// - 지역정보 disclosure group을 열면 아래의 뷰가 내려가게 만들고 싶음! -> 헤더뷰 height와 같이 연구,,
/// - 지역정보 disclosure group width 수정
/// - Picker 지우고 라이브러리로 변경
/// - 미묘한 간격,,,,,거슬림

// Todo: - Error fix
/// - 스크롤뷰가 아래까지 안내려가는 이슈......

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
            AsyncImage(url: URL(string: shopDetailImageURL)!) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: CGFloat.screenHeight * 0.2)
            } placeholder: {
                ProgressView()
            }
        }
    }
    
    struct ShopDetailBodyView: View {
        
        let shopDetailName: String
        let shopDetailCategoryName: String
        let shopDetailAddress: String
        let shopDetailAddressDetail: String
        
        @Binding var selectedShopDetailCategory: ShopDetailCategory
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 10) {
                            Text(shopDetailName)
                                .font(Font.pretendardBold28)
                            
                            Divider()
                                .frame(height: 25)
                            
                            Text(shopDetailCategoryName)
                                .font(Font.pretendardMedium18)
                        }
                        
                        DisclosureGroup(shopDetailAddress) {
                            HStack(spacing: 5) {
                                Text(shopDetailAddressDetail)
                                    .font(Font.pretendardRegular14)
                                
                                Image(systemName: "doc.on.doc")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                            }
                        }
                        .font(Font.pretendardMedium18)
                        
                        Spacer()
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
                    .foregroundColor(Color("DarkGrayColor"))
                }
                .padding(10)
                .frame(height: CGFloat.screenHeight * 0.1)
                .padding(.vertical, 10)
                
                Picker(selection: $selectedShopDetailCategory, label: Text(selectedShopDetailCategory.rawValue).font(Font.pretendardRegular16)) {
                    ForEach(ShopDetailCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .font(Font.pretendardRegular16)
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
            .background(Color.white)
            .cornerRadius(12)
        }
    }
    
    struct ShopDetailFooterView: View {
        
        @Binding var isReservationPresented: Bool
        
        var body: some View {
            HStack(spacing: 10) {
                VStack(spacing: 2) {
                    Image(systemName: "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundColor(Color.black)
                    
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
            .background(Color.white)
            .frame(alignment: .bottom)
            .navigationDestination(isPresented: $isReservationPresented) {
                ReservationView()
            }
        }
    }
}
