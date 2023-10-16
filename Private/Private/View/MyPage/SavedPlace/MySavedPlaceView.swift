//
//  MySavedPlaceView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI

struct MySavedPlaceView: View {
    @EnvironmentObject private var userStore: UserStore
    var body: some View {
        ScrollView {
            if userStore.mySavedPlaceList.isEmpty {
                Text("저장한 북마크가 없습니다.")
                    .font(.pretendardBold24)
                    .padding(.top, .screenHeight * 0.2 + 37.2)
            } else {
                ShopInfoCardView(mySavedPlaceList: userStore.mySavedPlaceList)
                
            }
        }
    }
}

struct MySavedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        MySavedPlaceView().environmentObject(UserStore())
    }
}
