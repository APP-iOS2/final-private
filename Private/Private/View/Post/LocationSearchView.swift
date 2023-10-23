//
//  LocationSearchView.swift
//  Private
//
//  Created by 변상우 on 10/10/23.
//

import SwiftUI

struct LocationSearchView: View {
    
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    @ObservedObject var detailCoordinator = DetailCoordinator.shared

    @Binding var showLocation: Bool
    @Binding var searchResult: SearchResult
    @Binding var isSearchedLocation: Bool
    
    @State private var searchText: String = ""
    @State private var inSearchMode = false
    var body: some View {
        VStack(alignment: .leading) {
            SearchBarTextField(text: $searchText, isEditing: $inSearchMode, placeholder: "원하는 위치명을 입력하세요.")
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(locationSearchStore.searchResultList, id: \.self) { location in
                        Button {
                            showLocation = false
                            searchResult = location
                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(location.title)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                                    .font(.pretendardMedium16)
                                    .foregroundStyle(Color.primary)
                                Text("\(location.roadAddress)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                                    .font(.pretendardRegular12)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        .padding()
                    }
                    

                }
            }
            Button {
                isSearchedLocation = true
                showLocation = false
            } label: {
                Text("원하시는 장소가 없으신가요?")
                    .font(.pretendardSemiBold16)
                    .foregroundStyle(Color.primary)
            }
            .onChange(of: searchText, perform: { _ in
                locationSearchStore.requestSearchLocationResultList(query: searchText)
            })
        }
        .padding()
        .onAppear {
            locationSearchStore.requestSearchLocationResultList(query: searchText)
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(showLocation: .constant(true), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")), isSearchedLocation: .constant(true))
    }
}
