//
//  SearchView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//
import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchStore: SearchStore
    @EnvironmentObject var followStore: FollowStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State private var searchTerm: String = ""
    @State private var trimmedSearchTerm: String = ""
    @State private var inSearchMode = false
    @State private var isSearchTextEmpty: Bool = true
    
    var body: some View {
            VStack(spacing: 0) {
                SearchBarView(searchTerm: $searchTerm, inSearchMode: $inSearchMode, isSearchTextEmpty: $isSearchTextEmpty)
                    .padding()
                ScrollView(showsIndicators: false) {
                    SearchPageView(searchTerm: $searchTerm)
                }
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                searchStore.fetchrecentSearchResult()
                searchTerm = ""
            }
    }
}
