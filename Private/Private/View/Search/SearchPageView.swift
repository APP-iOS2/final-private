//
//  SearchPageView.swift
//  Private
//
//  Created by 박범수 on 10/19/23.
//

import SwiftUI

struct SearchPageView: View {
    @EnvironmentObject var searchStore: SearchStore
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            RecentSearchListView()
            Spacer()
            Divider()
            RecentUserListView()
            Spacer()
        }
    }



    
    struct RecentSearchListView: View {
        @EnvironmentObject var searchStore: SearchStore
        
        var body: some View {
            VStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text("최근 검색어")
                        .font(.pretendardMedium24)
                        .padding()
                    
                    Divider().padding()
                }
                    if !searchStore.recentSearchResult.isEmpty {
                        ForEach(searchStore.recentSearchResult.prefix(5), id: \.self) { resultText in
                            RecentSearchRowView(resultText: resultText)
                        }
                } else {
                    Text("검색 기록이 없습니다")
                        .font(.pretendardRegular16)
                        .foregroundColor(.secondary)
                }
                Spacer().padding(.bottom, 10)
            }
        }
    }
    
    struct RecentSearchRowView: View {
        @EnvironmentObject var searchStore: SearchStore
        let resultText: String
        
        var body: some View {
            HStack {
                NavigationLink {
                    UserListView(searchTerm: resultText)
                } label: {
                    Text(resultText)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button {
                    searchStore.removeRecentSearchResult(resultText)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
            }
            .padding(.bottom, 8)
        }
    }
    
    struct RecentUserListView: View {
        @EnvironmentObject var searchStore: SearchStore

        var body: some View {
            VStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text("찾은 사용자")
                        .font(.pretendardMedium24)
                        .padding()
                    
                    Divider().padding()
                }
                VStack(alignment: .leading) {
                    if !searchStore.searchUserLists.isEmpty {
                        ForEach(searchStore.searchUserLists.prefix(3), id: \.self) { user in
                            RecentUserRowView(user: user)
                        }
                    } else {
                        Text("검색 기록이 없습니다")
                            .font(.pretendardRegular16)
                            .foregroundColor(.gray)
                    }
                    Spacer().padding(.bottom, 10)
                }
            }
        }
    }

    struct RecentUserRowView: View {
        @EnvironmentObject var searchStore: SearchStore
        @EnvironmentObject var followStore: FollowStore
        let user: User

        var body: some View {
            HStack {
                NavigationLink {
                    LazyView(OtherProfileView(user: user))
                } label: {
                    SearchUserCellView(user: user)
                }
                Spacer()
                Button {
                    searchStore.removeUserList(user)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                .padding(.trailing, 10)
            }
            .padding(.bottom, 8)
        }
    }

}
