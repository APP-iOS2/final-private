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
    @EnvironmentObject var followStore: FollowStore
    
    @State var isFollowing = false
    
    
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
                print("검색\(searchTerm)")
                await fetchSearchResults()
            }
        }
    }
    
    //searchUserLists에 영향? 주는 코드
    var searchUserResult: some View {
        ForEach(searchStore.searchUserLists, id: \.self) { user in
            NavigationLink {
                OtherPageView(user: user, isFollowing: $isFollowing)
            } label: {
                SearchUserCellView(user: user, isFollowing: $isFollowing)
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


