//
//  MySavedPlaceView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI

struct MySavedPlaceView: View {
    @EnvironmentObject private var userStore: UserStore
    
    @State private var isShowingLocation: Bool = false
    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    
    var body: some View {
        ScrollView {
            if userStore.mySavedPlaceList.isEmpty {
                Text("저장한 북마크가 없습니다.")
                    .font(.pretendardBold24)
                    .foregroundColor(.primary)
                    .padding(.top, .screenHeight * 0.2 + 37.2)
            } else {
                ShopInfoCardView(isShowingLocation: $isShowingLocation, searchResult: $searchResult, mySavedPlaceList: userStore.mySavedPlaceList)
            }
        }
        .sheet(isPresented: $isShowingLocation) {
            LocationDetailView(searchResult: $searchResult)
                .presentationDetents([.height(.screenHeight * 0.6), .large])
        }
    }
}

struct MySavedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        MySavedPlaceView().environmentObject(UserStore())
    }
}
