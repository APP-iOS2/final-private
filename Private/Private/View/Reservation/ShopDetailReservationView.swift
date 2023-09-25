//
//  ShopDetailReservationView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI

/*
 static let reservation = Reservation(
     shop: ShopStore.shop,
     date: Date().timeIntervalSince1970,
     time: "",
     isOpen: true,
     numberOfPeople: 4,
     totalPrice: ShopStore.shop.shopItems[0].price,
     reservedUser: UserStore.user
 )
 */

struct ShopDetailReservationView: View {
    
    @ObservedObject var shopStore: ShopStore
    
    var body: some View {
        VStack {
            LazyVStack {
                ForEach(0..<10) { _ in
                    ItemInfoView(shopStore: shopStore)
                        .padding(.horizontal, 10)
                }
            }
        }
    }
}

struct ShopDetailReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailReservationView(shopStore: ShopStore())
    }
}

//struct ShopDetailReservationCell: View {
//
//    let reservationName: String
//    let reservationPrice: String
//
//    var body: some View {
//
//        VStack {
//            Text(reservationName)
//            Text(reservationPrice)
//
//            HStack {
//                Text(reservationName)
//                    .font(Font.pretendardBold24)
//
//            }
////            Text("\(shopItem.price)원")
////                .font(Font.pretendardBold18)
////                .foregroundColor(Color("AccentColor"))
////                .padding(.bottom)
////
////            Text("2023.09.20 ~ 2023.12.25")  // 데이터에 없음
////                .font(Font.pretendardRegular14)
////                .foregroundColor(.secondary)
//        }
//        .frame(height: 100)
//        .padding()
//        .background(Color("SubGrayColor"))
//        .cornerRadius(12)
//    }
//}
