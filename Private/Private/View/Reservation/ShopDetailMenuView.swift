//
//  ShopDetailMenuView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI
import Kingfisher

struct ShopDetailMenuView: View {
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    
    let shopData: Shop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LazyVStack {
                ForEach(shopData.menu, id: \.self) { menu in
                    HStack(spacing: 10) {
                        KFImage(URL(string: menu.imageUrl)!)
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)                         
                            .cornerRadius(12)
                        
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
        ShopDetailMenuView(shopData: ShopStore.shop)
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
    }
}
