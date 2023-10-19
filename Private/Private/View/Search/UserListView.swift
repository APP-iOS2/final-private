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
    // searchStore: SearchStore() 형태로 초기화하면 두 번 호출되니까 이렇게 하면 안됨, SearchView.swift에서 이미 초기화
    @Binding var searchTerm: String
    
    var body: some View {
        VStack {
            if searchStore.searchUserLists.isEmpty {
                Text("해당 사용자가 없습니다.")
                    .font(.pretendardMedium16)
                    .foregroundColor(.gray)
                    .padding(.top)
            } else {
                searchUserResult
            }
            
            Spacer()
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
        ScrollView {
            LazyVStack {
                ForEach(searchStore.searchUserLists, id: \.self) { user in
                    NavigationLink {
                        LazyView(OtherPageView(user: user))
                    } label: {
                        SearchUserCellView(user: user)
                            .padding(.leading)
                    }
                }
            }
        }
    }
    
    func fetchSearchResults() async {
        await searchStore.searchUser(searchTerm: searchTerm)
        searchStore.addRecentSearch(searchTerm)
    }
    
}
