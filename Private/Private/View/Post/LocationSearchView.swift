//
//  LocationSearchView.swift
//  Private
//
//  Created by 변상우 on 10/10/23.
//

import SwiftUI

struct LocationSearchView: View {
    
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    
    @Binding var showLocation: Bool
    @Binding var searchResult: SearchResult
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchBarTextField(text: $searchText, placeholder: "원하는 위치명을 입력하세요.")
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(locationSearchStore.searchResultList, id: \.self) { location in
                        Button {
                            showLocation = false
                            searchResult = location
                        } label: {
                            Text("\(location.title)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                        }
                        .padding()
                    }
                }
            }
            .onChange(of: searchText, perform: { _ in
                locationSearchStore.requestSearchLocationResultList(query: searchText)
            })
        }
        .padding()
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(showLocation: .constant(true), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")))
    }
}
