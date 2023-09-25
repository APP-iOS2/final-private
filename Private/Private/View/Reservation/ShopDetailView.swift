//
//  ShopDetailView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI

/*
 static let shop = Shop(
 name: "맛집",
 category: Category.koreanFood,
 coord: NMGLatLng(lat: 36.444, lng: 127.332),
 address: "서울시 강남구",
 addressDetail: "7번 출구 어딘가",
 shopTelNumber: "010-1234-5678",
 shopInfo: "미슐랭 맛집",
 shopImageURL: "",
 shopItems: [shopItem],
 numberOfBookmark: 0
 )
 */

enum ShopDetailCategory: String, CaseIterable {
    case shopInfo = "가게 정보"
    case shopReservation = "예약"
    case shopCurrentReview = "최근 리뷰"
}

struct ShopDetailView: View {
    
    @State var selectedShopDetailCategory: ShopDetailCategory = .shopInfo
    
    @ObservedObject var shopStore: ShopStore
    @ObservedObject var reservationStore: ReservationStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    let dummyShop = ShopStore.shop
    let dummyImageString: String = "https://image.bugsm.co.kr/album/images/500/40912/4091237.jpg"
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                AsyncImage(url: URL(string: dummyImageString)!) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 10) {
                                Text(dummyShop.name)
                                    .font(Font.pretendardBold28)
                                
                                Divider()
                                    .frame(height: 25)
                                
                                Text(dummyShop.category.categoryName)
                                    .font(Font.pretendardMedium18)
                            }
                            
                            GeometryReader { geometry in
                                DisclosureGroup(dummyShop.address) {
                                    HStack(spacing: 5) {
                                        Text(dummyShop.addressDetail)
                                            .font(Font.pretendardRegular14)
                                        
                                        Image(systemName: "doc.on.doc")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                    }
                                }
                                .font(Font.pretendardMedium18)
                                .frame(width: geometry.size.width - 100, height: geometry.size.height)
                            }
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
                    .frame(height: 100)
                    
                    Divider()
                    
                    Picker(selection: $selectedShopDetailCategory, label: Text(selectedShopDetailCategory.rawValue).font(Font.pretendardRegular16)) {
                        ForEach(ShopDetailCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
                                .font(Font.pretendardRegular16)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(10)
                    
                    ScrollView {
                        switch selectedShopDetailCategory {
                        case .shopInfo:
                            ShopwDetailInfoView()
                        case .shopReservation:
                            ShopDetailReservationView(shopStore: shopStore, reservationStore: reservationStore)
                        case .shopCurrentReview:
                            ShopwDetailCurrentReviewView()
                        }
                    }
                    .padding([.top, .horizontal], 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .offset(CGSize(width: 0, height: 120))
            }
        }
    }
}

struct ShopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailView(shopStore: ShopStore(), reservationStore: ReservationStore(), root: .constant(true), selection: .constant(4))
    }
}

struct ShopwDetailInfoView: View {
    
    let dummyImage: [URL] = Array(repeating: URL(string: "https://image.bugsm.co.kr/album/images/500/40912/4091237.jpg")!, count: 10)
    let dummyBusinessHours: String = """
    월화 휴무
    14:30 - 18:00 브레이크 타임
    수 12:00 - 20:00
    목 12:00 - 20:00
    금 12:00 - 20:00
    토 12:00 - 20:00
    일 12:00 - 20:00
    """
    let dummyShop = ShopStore.shop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(dummyImage, id: \.self) { imageURL in
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .frame(height: 100)
            
            Divider()
            
            Text(dummyShop.shopInfo)
                .font(Font.pretendardRegular16)
            
            Divider()
            
            HStack(spacing: 10) {
                Image(systemName: "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                
                Text("영업 시간")
                    .font(Font.pretendardMedium18)
                
                Spacer()
                
                ZStack {
                    Text("영업 전")
                        .font(Font.pretendardMedium18)
                        .padding(10)
                }
                .background(Color("SubGrayColor"))
                .cornerRadius(12)
            }
            
            VStack(spacing: 0) {
                Text(dummyBusinessHours)
                    .font(Font.pretendardRegular16)
                    .lineSpacing(5)
                    .frame(alignment: .leading)
            }
        }
    }
}
