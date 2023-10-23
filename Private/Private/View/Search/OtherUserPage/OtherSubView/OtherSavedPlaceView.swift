//
//  OtherSavedPlaceView.swift
//  Private
//
//  Created by 박범수 on 10/22/23.
//

import SwiftUI

struct OtherSavedPlaceView: View {
    @EnvironmentObject private var userStore: UserStore
    
    @State private var isShowingLocation: Bool = false
    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    
    let user:User
    
    var body: some View {
        ScrollView {
            if userStore.otherSavedPlaceList.isEmpty {
                Text("저장한 북마크가 없습니다.")
                    .font(.pretendardBold24)
                    .foregroundColor(.primary)
                    .padding(.top, .screenHeight * 0.2 + 37.2)
            } else {
                ShopInfoCardView(isShowingLocation: $isShowingLocation, searchResult: $searchResult, mySavedPlaceList: userStore.otherSavedPlaceList)
            }
        }
        .sheet(isPresented: $isShowingLocation) {
            LocationDetailView(searchResult: $searchResult)
                .presentationDetents([.height(.screenHeight * 0.6), .large])
        }
    }
}
