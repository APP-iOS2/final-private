//
//  ShopStore.swift
//  Private
//
//  Created by 변상우 on 2023/09/22.
//

import Foundation
import NMapsMap

final class ShopStore: ObservableObject {
    @Published var shopList: [Shop] = []
    
    init() {
        
    }
    
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
    
    static let shopItem = ShopItem(item: "비빔밥", price: "10000", image: "")
    
}
