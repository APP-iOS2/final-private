//
//  ItemInfoView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/22.
//

import SwiftUI

struct ItemInfoView: View {
    
    @ObservedObject var shopStore: ShopStore
    @ObservedObject var reservationStore: ReservationStore
    private let shopItem = ShopStore.shopItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .opacity(0)
            
            HStack {
                Text(shopItem.item)
                    .font(Font.pretendardBold24)
                
                Spacer()
                NavigationLink {
                    ReservationView(shopStore: shopStore, reservationStore: reservationStore)
                } label: {
                    Text("예약하기")
                }


                
            }
            Text("\(shopItem.price)원")
                .font(Font.pretendardBold18)
                .foregroundColor(Color("AccentColor"))
                .padding(.bottom)

            Text("2023.09.20 ~ 2023.12.25")  // 데이터에 없음
                .font(Font.pretendardRegular14)
                .foregroundColor(.secondary)
        }
        .frame(height: 100)
        .padding()
        .background(Color("SubGrayColor"))
        .cornerRadius(12)
    }
}

struct ItemInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ItemInfoView(shopStore: ShopStore(), reservationStore: ReservationStore())
            .frame(height: 100)
    }
}
