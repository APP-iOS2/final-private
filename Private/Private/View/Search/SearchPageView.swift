//
//  SearchPageView.swift
//  Private
//
//  Created by 박범수 on 10/19/23.
//

import SwiftUI

struct SearchPageView: View {
    
    @Binding var searchTerm: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Divider()
            RecentSearchListView(searchTerm: $searchTerm)
            Spacer()
            Divider()
            RecentUserListView()
        }
    }



    
    struct RecentSearchListView: View {
        @EnvironmentObject var searchStore: SearchStore
        @Binding var searchTerm: String
        
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
                            RecentSearchRowView(searchTerm: $searchTerm, resultText: resultText)
                        }
                } else {
                    Text("최근 검색 기록이 없습니다")
                        .font(.pretendardRegular16)
                        .foregroundColor(.secondary)
                }
                
                Spacer().padding(.bottom, 10)
            }
        }
    }
    
    struct RecentSearchRowView: View {
        @EnvironmentObject var searchStore: SearchStore
        @Binding var searchTerm: String
        let resultText: String
        
        var body: some View {
            HStack {
                NavigationLink {
                    UserListView(searchTerm: $searchTerm)
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
                    Text("최근 찾은 사용자")
                        .font(.pretendardMedium24)
                        .padding()
                    
                }
                VStack(alignment: .leading) {
                    if !searchStore.searchUserLists.isEmpty {
                        ForEach(searchStore.searchUserLists, id: \.self) { user in
                            RecentUserRowView(user: user)
                        }
                    } else {
                        Text("최근 검색 기록이 없습니다")
                            .font(.pretendardRegular16)
                            .foregroundColor(.gray)
                    }
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
                    OtherPageView(user: user)
                } label: {
                    SearchUserCellView(user: user)
                }
                Spacer()
                Button {
                    searchStore.removeRecentSearchResult(user.nickname)
                } label: {
                    Image(systemName: "xmark.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 8)
        }
    }

}
