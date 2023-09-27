//
//  MySavedPlaceView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI

struct MySavedPlaceView: View {
    var body: some View {
        ScrollView {
            ShopInfoCardView()
            Divider()
                .background(Color.primary)
                .frame(width: .screenWidth * 0.9)
        }
    }
}

struct MySavedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        MySavedPlaceView()
    }
}
