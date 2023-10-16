//
//  OtherSavedPlaceView.swift
//  Private
//
//  Created by 박범수 on 10/5/23.
//

import SwiftUI

struct OtherSavedPlaceView: View {
    let user: User
    let otherSavedPlaceList: [MyFeed]
    var body: some View {
        ScrollView {
            if otherSavedPlaceList.isEmpty {
                Text("저장한 북마크가 없습니다.")
                    .font(.pretendardBold24)
                    .padding(.top, .screenHeight * 0.2 + 37.2)
            } else {
                ShopInfoCardView(mySavedPlaceList: otherSavedPlaceList)
            }
        }
    }
}

struct OtherSavedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSavedPlaceView(user: User(), otherSavedPlaceList: [MyFeed()])
    }
}
