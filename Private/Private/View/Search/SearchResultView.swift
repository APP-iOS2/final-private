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
    @EnvironmentObject private var followStore: FollowStore
    
    var body: some View {
        ScrollView {
            VStack {
                if searchStore.searchUserLists.isEmpty {
                    Text("해당 사용자가 없습니다.")
                        .foregroundColor(.gray)
                        .padding(.top)
                } else {
                    searchUserResult
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .onAppear {
            Task {
                await fetchSearchResults()
            }
        }
    }
    
    
    var searchUserResult: some View {
        // 팔로잉 되어있는 사람 체크 함수 plus
        ForEach(searchStore.searchUserLists, id: \.self) { user in
            NavigationLink {
                OtherPageView(user: user)
            } label: {
                SearchUserCellView(user: user)
                    .environmentObject(FollowStore())
            }
        }
    }
    
    func fetchSearchResults() async {
        await searchStore.searchUser(searchTerm: searchTerm)
        searchStore.addRecentSearch(searchTerm)
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(searchTerm: "사용자 아무개")
            .environmentObject(SearchStore())
    }
}


