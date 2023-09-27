//
//  ShopDetailMenuView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI

struct ShopDetailMenuView: View {
    
    let dummyShop = ShopStore.shop
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LazyVStack {
                ForEach(dummyShop.menu, id: \.self) { menu in
                    HStack(spacing: 10) {
                        AsyncImage(url: URL(string: menu.imageUrl)!) { image in
                            image.resizable()
                                .frame(width: 120, height: 120)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(12)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(menu.name)")
                                .font(Font.pretendardMedium24)
                            
                            Text("\(menu.price)")
                                .font(Font.pretendardRegular16)
                        }
                        
                        Spacer()
                    }
                    .padding(10)
                }
            }
        }
    }
}

struct ShopDetailMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailMenuView()
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
    }
}
