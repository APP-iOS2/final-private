//
//  ShopDetailMenuView.swift
//  Private
//
//  Created by H on 2023/09/22.
//

import SwiftUI

struct ShopDetailMenuView: View {
    
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

struct ShopDetailMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailMenuView()
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
    }
}
