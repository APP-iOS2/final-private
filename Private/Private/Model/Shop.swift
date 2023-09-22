//
//  Shop.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation
import NMapsMap

struct Shop {
    let id: String = UUID().uuidString
    var name: String
    var category: Category
    var coord: NMGLatLng
    var address: String
    var addressDetail: String
    var shopTelNumber: String
    var shopInfo: String
    var shopImageURL: String
    var shopItems: ShopItem
    var numberOfBookmark: Int
}

struct ShopItem {
    var item: String
    var price: String
    var image: String
}
