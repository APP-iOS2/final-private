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
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    
    var body: some View {
        VStack {
            LazyVStack {
                ForEach(0..<10) { _ in
                    ZStack {
                        ItemInfoView()
                        
                        HStack {
                            Spacer()
                            NavigationLink {
                                ReservationView()
                            } label: {
                                Text("예약하기")
                                    .font(Font.pretendardBold18)
                                    .padding()
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
    }
}

struct ShopDetailReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailReservationView()
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
    }
}
