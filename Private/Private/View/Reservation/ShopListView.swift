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

let dummyCafes: [Shop] = [
    Shop(
    name: "카페맛집1",
    category: .cafe,
    coord: CodableNMGLatLng(lat: 36.444, lng: 127.332),
    address: "서울 강남구 강남대로 96길 22 2층",
    addressDetail: "7번 출구 어딘가",
    shopTelNumber: "010-1234-5678",
    shopInfo: "미슐랭 맛집",
    shopImageURL: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg",
    shopOwner: "백종원",
    businessNumber: "123-12-1234",
    bookmarks: [],
    menu: [
        ShopItem(name: "돈코츠 라멘", price: 11000, imageUrl: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg"),
        ShopItem(name: "마제소바", price: 10000, imageUrl: "https://www.kfoodtimes.com/news/photo/202105/16015_27303_5527.png"),
        ShopItem(name: "차슈덮밥", price: 12000, imageUrl: "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/411/3435af5cc6041f247e89a65b1a1d73c5_res.jpeg")
    ],
    regularHoliday: ["월요일", "화요일", "수요일", "목요일"],
    temporaryHoliday: [Date()],
    breakTimeHours:  [
        "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
        "화요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "수요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "목요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 18, endMinute: 0),
        "금요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "토요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 15, endMinute: 0),
        "일요일": BusinessHours(startHour: 12, startMinute: 0, endHour: 16, endMinute: 0)
    ],
    weeklyBusinessHours:  [
        "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
        "화요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "수요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "목요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "금요일": BusinessHours(startHour:15, startMinute: 0, endHour: 17, endMinute: 0),
        "토요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "일요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0)
    ]),
    
    Shop(
    name: "카페맛집2",
    category: .cafe,
    coord: CodableNMGLatLng(lat: 36.444, lng: 127.332),
    address: "서울 강남구 강남대로 96길 22 2층",
    addressDetail: "7번 출구 어딘가",
    shopTelNumber: "010-1234-5678",
    shopInfo: "미슐랭 맛집",
    shopImageURL: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg",
    shopOwner: "백종원",
    businessNumber: "123-12-1234",
    bookmarks: [],
    menu: [
        ShopItem(name: "돈코츠 라멘", price: 11000, imageUrl: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg"),
        ShopItem(name: "마제소바", price: 10000, imageUrl: "https://www.kfoodtimes.com/news/photo/202105/16015_27303_5527.png"),
        ShopItem(name: "차슈덮밥", price: 12000, imageUrl: "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/411/3435af5cc6041f247e89a65b1a1d73c5_res.jpeg")
    ],
    regularHoliday: ["월요일", "화요일", "수요일", "목요일"],
    temporaryHoliday: [Date()],
    breakTimeHours:  [
        "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
        "화요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "수요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "목요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 18, endMinute: 0),
        "금요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "토요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 15, endMinute: 0),
        "일요일": BusinessHours(startHour: 12, startMinute: 0, endHour: 16, endMinute: 0)
    ],
    weeklyBusinessHours:  [
        "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
        "화요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "수요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "목요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "금요일": BusinessHours(startHour:15, startMinute: 0, endHour: 17, endMinute: 0),
        "토요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "일요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0)
    ]),
    
    Shop(
    name: "카페맛집3",
    category: .cafe,
    coord: CodableNMGLatLng(lat: 36.444, lng: 127.332),
    address: "서울 강남구 강남대로 96길 22 2층",
    addressDetail: "7번 출구 어딘가",
    shopTelNumber: "010-1234-5678",
    shopInfo: "미슐랭 맛집",
    shopImageURL: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg",
    shopOwner: "백종원",
    businessNumber: "123-12-1234",
    bookmarks: [],
    menu: [
        ShopItem(name: "돈코츠 라멘", price: 11000, imageUrl: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg"),
        ShopItem(name: "마제소바", price: 10000, imageUrl: "https://www.kfoodtimes.com/news/photo/202105/16015_27303_5527.png"),
        ShopItem(name: "차슈덮밥", price: 12000, imageUrl: "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/411/3435af5cc6041f247e89a65b1a1d73c5_res.jpeg")
    ],
    regularHoliday: ["월요일", "화요일", "수요일", "목요일"],
    temporaryHoliday: [Date()],
    breakTimeHours:  [
        "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
        "화요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "수요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "목요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 18, endMinute: 0),
        "금요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
        "토요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 15, endMinute: 0),
        "일요일": BusinessHours(startHour: 12, startMinute: 0, endHour: 16, endMinute: 0)
    ],
    weeklyBusinessHours:  [
        "월요일": BusinessHours(startHour: 0, startMinute: 0, endHour: 0, endMinute: 0),
        "화요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "수요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "목요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "금요일": BusinessHours(startHour:15, startMinute: 0, endHour: 17, endMinute: 0),
        "토요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0),
        "일요일": BusinessHours(startHour: 15, startMinute: 0, endHour: 17, endMinute: 0)
    ])]

enum ShopListSortCriterion: String, CaseIterable {
    case basic = "기본순"
    case bookmark = "북마크순"
    case distance = "거리순"
}

struct ShopListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let dummyShops: [Shop] = Array(repeating: ShopStore.shop, count: 5) + dummyCafes

    @EnvironmentObject var shopStore: ShopStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State var selectedShopCategory: Category = .koreanFood
    @State var selectedShopListSortCriterion: ShopListSortCriterion = .basic
    
    @State var isShowingSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                Text("\(selectedShopCategory.categoryName), \(selectedShopListSortCriterion.rawValue)")
                    .font(Font.pretendardSemiBold16)
                
                Spacer()
                
                Button {
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
                ForEach(dummyShops.filter({ shop in
                    return shop.category == selectedShopCategory
                }), id: \.self) { shop in
                    ShopListCell(shop: shop)
                        .padding(.vertical, 5)
                        .foregroundColor(colorScheme == ColorScheme.dark ? Color.white : Color.black)
                }
            }
        }
        .padding(10)
        .sheet(isPresented: $isShowingSheet) {
            ShopListFilterSheetView(selectedShopCategory: $selectedShopCategory, selectedShopListSortCriterion: $selectedShopListSortCriterion, isShowingSheet: $isShowingSheet)
        }
        
    }
}

struct ShopListView_Previews: PreviewProvider {
    static var previews: some View {
        ShopListView(root: .constant(true), selection: .constant(4))
    }
}

struct ShopListCell: View {
    
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
                ShopDetailView(shopData: shop)
            }
        }
    }
}

struct ShopListFilterSheetView: View {
    
    @Binding var selectedShopCategory: Category
    @Binding var selectedShopListSortCriterion: ShopListSortCriterion
    
    @Binding var isShowingSheet: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Section {
                    FlowLayout(mode: .scrollable, items: Category.allCases, itemSpacing: 10) { data in
                        Button {
                            selectedShopCategory = data
                            print(selectedShopCategory.categoryName)
                        } label: {
                            Text(data.categoryName)
                                .font(Font.pretendardBold18)
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
                    FlowLayout(mode: .scrollable, items: ShopListSortCriterion.allCases, itemSpacing: 10) { data in
                        Button {
                            selectedShopListSortCriterion = data
                        } label: {
                            Text(data.rawValue)
                                .font(Font.pretendardBold18)
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
//     var body: some View {
//         List {
//             ForEach(shopStore.shopList, id: \.self) { shopData in
//                 NavigationLink {
//                     ShopDetailView(shopData: shopData)
//                 } label: {
//                     HStack(alignment: .top){
//                         KFImage(URL(string: shopData.shopImageURL)!)
//                                         .onFailure({ error in
//                                             print("Error : \(error)")
//                                         })
//                                         .resizable()
//                                         .frame(width: 80, height: 80)
//                                         .clipped()
//                                         .padding(.trailing)
                        
//                         VStack(alignment: .leading) {
//                             Text("\(shopData.category.categoryName)")
//                             Text(shopData.name)
//                         }
//                     }
                }
            }
        }
    }
}
