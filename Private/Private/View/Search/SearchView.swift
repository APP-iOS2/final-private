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
    @State private var inSearchMode = false
    @State private var isSearchTextEmpty: Bool = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBarTextField(text: $searchTerm, isEditing: $inSearchMode, placeholder: "사용자 검색")
                    .padding()
                
                ScrollView(showsIndicators: false) {
                    ZStack {
                        if inSearchMode {
                            UserListView(searchTerm: $searchTerm)
                        } else {
                            SearchPageView(searchTerm: $searchTerm)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .onAppear {
                searchStore.fetchrecentSearchResult()
                searchTerm = ""
            }
        }
    }
}
