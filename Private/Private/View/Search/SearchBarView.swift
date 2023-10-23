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
    @State private var contiuneOnboarding = false
    
    var body: some View {
        VStack {
            HStack {
                SearchBarTextField(text: $searchTerm, isEditing: $inSearchMode, placeholder: "사용자 닉네임 검색")
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
//                    .onChange(of: searchTerm) { newValue in
//                        let trimmedSearchTerm = searchTerm.trimmingCharacters(in: .whitespaces)
//                    }
                    .onSubmit {
                        contiuneOnboarding = true
                        Task {
                            await searchStore.searchUser(searchTerm: searchTerm)
                            searchStore.addRecentSearch(searchTerm)
                        }
                    }
                    .navigationDestination(isPresented: $contiuneOnboarding) {
                        UserListView(searchTerm: searchTerm.trimmingCharacters(in: .whitespaces))
                    }
                }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}
