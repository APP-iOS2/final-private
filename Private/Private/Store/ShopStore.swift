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
        name: "라면맛집",
        category: .koreanFood,
        coord: NMGLatLng(lat: 36.444, lng: 127.332),
        address: "서울시 강남구",
        addressDetail: "7번 출구 어딘가",
        shopTelNumber: "010-1234-5678",
        shopInfo: "미슐랭 맛집",
        shopImageURL: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg",
        bookmarks: [],
        menu: [
            ShopItem(name: "돈코츠 라멘", price: 11000, imageUrl: "https://www.kkday.com/ko/blog/wp-content/uploads/japan_food_3.jpeg"),
            ShopItem(name: "마제소바", price: 10000, imageUrl: "https://www.kfoodtimes.com/news/photo/202105/16015_27303_5527.png"),
            ShopItem(name: "차슈덮밥", price: 12000, imageUrl: "https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/411/3435af5cc6041f247e89a65b1a1d73c5_res.jpeg")
        ],
        regularHoliday: ["월요일"],
        temporayHoliday: [],
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
        ])
    
//    var weeklyBusinessHours: [String: BusinessHours] = [
//        "월요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
//        "화요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
//        "수요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
//        "목요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 18, endMinute: 0),
//        "금요일": BusinessHours(startHour: 9, startMinute: 0, endHour: 17, endMinute: 30),
//        "토요일": BusinessHours(startHour: 10, startMinute: 0, endHour: 15, endMinute: 0),
//        "일요일": BusinessHours(startHour: 12, startMinute: 0, endHour: 16, endMinute: 0)
//    ]
    
}
