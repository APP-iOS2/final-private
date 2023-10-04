//
//  SearchView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var searchStore: SearchStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State private var searchTerm: String = ""
    @State private var trimmedSearchTerm: String = ""
    @State private var isSearchTextEmpty: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            searchTextField
            ScrollView(showsIndicators: false) {
                recentSearchText
                recentSearchResult
                // 위 검색어 텍스트 아래 유저 리스트
                
                    Spacer()
                recentUserText
                resentUserResult
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
    
    // seach bar
    var searchTextField: some View {
        VStack {
            HStack {
                NavigationLink {
                    SearchResultView(searchTerm: trimmedSearchTerm)
                } label: {
                    EmptyView()
                }
                .disabled(isSearchTextEmpty)
                
                SearchBarTextField(text: $searchTerm, placeholder: "사용자 검색")
                    .onChange(of: searchTerm) { newValue in
                        trimmedSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
                        if trimmedSearchTerm.isEmpty {
                            isSearchTextEmpty = true
                        } else {
                            isSearchTextEmpty = false
                        }
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .padding(.bottom, 70)
        }
    }
    
    var recentSearchText: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("최근 검색어")
                    .fontWeight(.bold)
                Spacer()
            }
        }
        .padding()
    }
    
    var recentSearchResult: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding()
            
            if !searchStore.recentSearchResult.isEmpty {
                ForEach(searchStore.recentSearchResult, id: \.self) { resultText in
                    HStack {
                        NavigationLink {
                            SearchResultView(searchTerm: resultText)
                        } label: {
                            Text(resultText)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button {
                            searchStore.removeRecentSearchResult(resultText)
                        } label: {
                            Image(systemName: "xmark.fill")
                        }
                    }
                    .padding(.bottom, 8)
                }
            } else {
                Text("최근 검색 기록이 없습니다")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom, 220)
    }
    
    var recentUserText: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("최근 찾은 사용자")
                    .fontWeight(.bold)
                
                Spacer()
            }
        }
        .padding()
    }
    
    var resentUserResult: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding()
            
            if !searchStore.searchUserLists.isEmpty {
                ForEach(searchStore.searchUserLists, id: \.self) { user in
                    HStack {
                        NavigationLink {
                            SearchResultView(searchTerm: user.nickname)
                        } label: {
                            Text(user.nickname)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button {
                            searchStore.removeRecentSearchResult(user.nickname)
                        } label: {
                            Image(systemName: "xmark.fill")
                        }
                    }
                    .padding(.bottom, 8)
                }
            } else {
                Text("최근 검색 기록이 없습니다")
                    .foregroundColor(.secondary)
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(root: .constant(true), selection: .constant(2))
            .environmentObject(SearchStore())
    }
}
