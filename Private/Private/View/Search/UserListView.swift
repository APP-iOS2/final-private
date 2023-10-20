//
//  UserListView.swift
//  Private
//
//  Created by 박범수 on 10/19/23.
//

import SwiftUI

struct UserListView: View {
    
    @EnvironmentObject var searchStore: SearchStore
    @EnvironmentObject var followStore: FollowStore
    var searchTerm: String
    
    @State private var searchText: String = ""
    @State private var trimmedSearchTerm: String = ""
    @State private var inSearchMode = false
    @State private var isSearchTextEmpty: Bool = true
    
    var body: some View {
        ScrollView {
            LazyVStack {
                SearchBarView(searchTerm: $searchText, inSearchMode: $inSearchMode, isSearchTextEmpty: $isSearchTextEmpty)
                    .padding()
                searchResultView
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .backButtonArrow()
        .onAppear {
            Task {
                await searchStore.searchUser(searchTerm: searchTerm)
                searchStore.addRecentSearch(searchTerm)
            }
        }
    }
        
        var searchResultView: some View {
            ScrollView {
                if searchStore.searchUserLists.isEmpty {
                    Text("검색 결과가 없습니다.")
                        .foregroundColor(.gray)
                        .padding(.top)
                } else {
                    ForEach(searchStore.searchUserLists, id: \.self) { user in
                        NavigationLink {
                            LazyView(OtherProfileView(user: user))
                        } label: {
                            SearchUserCellView(user: user)
                                .padding(.leading)
                        }
                    }
                }
            }
        }
    }
