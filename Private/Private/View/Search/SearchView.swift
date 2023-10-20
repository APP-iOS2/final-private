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
        NavigationView {
            VStack(spacing: 0) {
                searchTextField
                ScrollView(showsIndicators: false) {
                    SearchPageView(searchTerm: $searchTerm)
                }
                Spacer()
            }
            .onAppear {
                searchStore.fetchrecentSearchResult()
                searchTerm = ""
            }
        }
    }
    
    var searchTextField: some View{
        VStack {
            HStack {
                SearchBarTextField(text: $searchTerm, isEditing: $inSearchMode, placeholder: "사용자 검색")
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onChange(of: searchTerm) { newValue in
                        trimmedSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
                        if trimmedSearchTerm.isEmpty {
                            isSearchTextEmpty = true
                        } else {
                            isSearchTextEmpty = false
                        }
                    }
                if !searchTerm.isEmpty {
                    NavigationLink {
                        UserListView(searchTerm: trimmedSearchTerm)
                    } label: {
                        Image(systemName: "arrowshape.right.fill")
                            .foregroundColor(Color("AccentColor"))
                    }
                    .disabled(isSearchTextEmpty)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}
