//
//  SearchView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//
import SwiftUI

struct SearchView: View {
    @ObservedObject private var searchStore = SearchStore()
    @EnvironmentObject var followStore: FollowStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State var searchTerm: String = ""
    @State var inSearchMode = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchTerm, isEditing: $inSearchMode)
                    .padding()
                
                ScrollView(showsIndicators: false) {
                    ZStack {
                        if inSearchMode {
                            UserListView(searchStore: searchStore, searchTerm: $searchTerm)
                        } else {
                            SearchPageView(searchStore: searchStore, searchTerm: $searchTerm)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .onAppear {
                searchStore.fetchUsers()
                searchTerm = ""
            }
        }
    }
}

