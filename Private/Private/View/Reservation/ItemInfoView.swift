//
//  ItemInfoView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/22.
//

import SwiftUI

struct ItemInfoView: View {
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    private let shopItem = ShopStore.shop.menu[0]
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .opacity(0)
            
            HStack {
                Text(shopItem.name)
                    .font(.pretendardBold24)
                
                Spacer()
            }
            
            Text("\(shopItem.price)원")
                .font(.pretendardBold18)
                .foregroundColor(Color("AccentColor"))
                .padding(.bottom)

            Text("2023.09.20 ~ 2023.12.25")  // 데이터에 없음
                .font(.pretendardRegular14)
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
        ItemInfoView()
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
            .frame(height: 100)
    }
}
