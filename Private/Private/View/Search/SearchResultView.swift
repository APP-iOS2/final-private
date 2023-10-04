//
//  SearchResultView.swift
//  Private
//
//  Created by 박범수 on 2023/09/22.
//

import SwiftUI

struct SearchResultView: View {
    var searchTerm: String
    
    @EnvironmentObject var searchStore: SearchStore
    
    var body: some View {
        ScrollView {
            VStack {
                searchUserResult
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .onAppear {
            Task {
                await searchStore.searchUser(searchTerm: searchTerm)
                searchStore.addRecentSearch(searchTerm)
            }
        }
    }
    
    var searchUserResult: some View {
        ScrollView {
            if searchStore.searchUserLists.isEmpty {
                Text("해당 사용자가 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.top)
            } else {
                ForEach(searchStore.searchUserLists, id: \.self) { user in
                    NavigationLink {
//                         MyPageView(user: user)
                    } label: {
                        SearchUserCellView(user: user)
                    }
                }
            }
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(searchTerm: "사용자 아무개")
            .environmentObject(SearchStore())
    }
}
