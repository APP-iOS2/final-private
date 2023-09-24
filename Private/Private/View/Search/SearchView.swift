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
                recentUserText
                resentUserResult
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal)
        .onAppear {
//            searchViewModel.fetchRecentSearchHistories()
            searchTerm = ""
        }
    }
    
    var searchTextField: some View {
        VStack {
            HStack {
                NavigationLink {
                    SearchResultView(searchTerm: trimmedSearchTerm)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
                .disabled(isSearchTextEmpty)
                
                TextField("사용자 검색", text: $searchTerm)
                    .textInputAutocapitalization(.never) // 첫글자 대문자 비활성화
                    .disableAutocorrection(true) // 자동수정 비활성화
                    .onChange(of: searchTerm) { newValue in
                        trimmedSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
                        if trimmedSearchTerm.isEmpty {
                            isSearchTextEmpty = true
                        } else {
                            isSearchTextEmpty = false
                        }
                    }
                
                if !searchTerm.isEmpty {
                    Button {
                        searchTerm = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 5)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
            }
            .padding(.bottom, 30)
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
                    .foregroundColor(.gray)
            }
        }
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
                    .foregroundColor(.gray)
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(root: .constant(true), selection: .constant(2))
    }
}
