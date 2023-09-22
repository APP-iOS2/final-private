//
//  ReservationView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct ReservationView: View {
    
    @ObservedObject var shopStore: ShopStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            ItemInfoView(shopStore: shopStore)
        }
        .padding()
        
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(shopStore: ShopStore(), root: .constant(true), selection: .constant(4))
    }
}
