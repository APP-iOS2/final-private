//
//  SearchView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//
import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var searchStore: SearchStore
    @EnvironmentObject private var followStore: FollowStore
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @State private var searchTerm: String = ""
    @State private var isSearchTextEmpty: Bool = true
    @State private var isNavigationActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchTextField
                ScrollView(showsIndicators: false) {
                    Divider()
                    RecentSearchListView(searchTerm: $searchTerm)
                    Spacer()
                    Divider()
                    RecentUserListView(searchTerm: $searchTerm)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .onAppear {
                print(" 팔로값 1: \(followStore.followCheck)")
                print(" 팔로값 2: \(followStore.followers)")
                print(" 팔로값 3: \(followStore.following)")
                print(" 팔로값 4: \(followStore.followerList)")
                print(" 팔로값 5: \(followStore.followingList)")
                searchStore.fetchrecentSearchResult()
                searchTerm = ""
            }
        }
    }
    
    var searchTextField: some View {
        VStack {
            HStack {
                SearchBarTextField(text: $searchTerm, placeholder: "사용자 검색")
                    .onChange(of: searchTerm) { newValue in
                        isSearchTextEmpty = newValue.trimmingCharacters(in: .whitespaces).isEmpty
                    }
                
                NavigationLink {
                    SearchResultView(searchTerm: searchTerm)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
                .disabled(isSearchTextEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
    
    
    struct RecentSearchListView: View {
        @EnvironmentObject var searchStore: SearchStore
        @Binding var searchTerm: String
        
        var body: some View {
            VStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text("최근 검색어")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    Divider().padding()
                }
                    if !searchStore.recentSearchResult.isEmpty {
                        ForEach(searchStore.recentSearchResult.prefix(5), id: \.self) { resultText in
                            RecentSearchRowView(searchTerm: $searchTerm, resultText: resultText)
                        }
                } else {
                    Text("최근 검색 기록이 없습니다")
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
                NavigationLink(
                    destination: SearchResultView(searchTerm: resultText),
                    label: {
                        Text(resultText)
                            .foregroundColor(.gray)
                    }
                )
                Spacer()
                Button {
                    searchStore.removeRecentSearchResult(resultText)
                } label: {
                    Image(systemName: "xmark.fill")
                }
            }
            .padding(.bottom, 8)
        }
    }
    
    struct RecentUserListView: View {
        @EnvironmentObject var searchStore: SearchStore
        @Binding var searchTerm: String

        var body: some View {
            VStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Text("최근 찾은 사용자")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    Divider().padding()
                }
                
                if !searchStore.searchUserLists.isEmpty {
                    ForEach(searchStore.searchUserLists, id: \.self) { user in
                        RecentUserRowView(user: user)
                    }
                } else {
                    Text("최근 검색 기록이 없습니다")
                        .foregroundColor(.secondary)
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


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(root: .constant(true), selection: .constant(2))
            .environmentObject(SearchStore())
    }
}
