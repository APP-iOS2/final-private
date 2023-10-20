//
//  SearchBarView.swift
//  Private
//
//  Created by 박범수 on 10/20/23.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var searchStore: SearchStore
    @Binding var searchTerm: String
    @Binding var inSearchMode: Bool
    @Binding var isSearchTextEmpty: Bool
    
    var body: some View {
        VStack {
            HStack {
                SearchBarTextField(text: $searchTerm, isEditing: $inSearchMode, placeholder: "사용자 검색")
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onChange(of: searchTerm) { newValue in
                        let trimmedSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
                        if trimmedSearchTerm.isEmpty {
                            isSearchTextEmpty = true
                        } else {
                            isSearchTextEmpty = false
                        }
                    }
                
                if !searchTerm.isEmpty {
                        NavigationLink {
                            UserListView(searchTerm: searchTerm.trimmingCharacters(in: .whitespaces))
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
