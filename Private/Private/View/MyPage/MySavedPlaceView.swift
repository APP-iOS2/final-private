//
//  MySavedPlaceView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI

struct MySavedPlaceView: View {
    @ObservedObject var userStore: UserStore
    var body: some View {
        ScrollView {
            if userStore.user.bookmark.isEmpty {
                Text("저장한 북마크가 없습니다.")
                    .font(.pretendardBold24)
            } else {
//                ShopInfoCardView(userStore: UserStore())
                Divider()
                    .background(Color.primary)
                    .frame(width: .screenWidth * 0.9)
            }
        }
    }
}

struct MySavedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        MySavedPlaceView(userStore: UserStore())
    }
}
