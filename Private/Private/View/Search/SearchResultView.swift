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
    
    var body: some View {
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
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        // 버튼 눌러도 다시 실행이 안됨 -> follow버튼 눌렀을때  await fetchSearchResults() 다시 실행되게 하기 !!!!! refreshable? -> 해도 수동으로 업데이트 코드 추가! +) !로 인해 실행 안되는 문제도 보기
        .onAppear {
                Task {
                    await fetchSearchResults()
                }
        }
        .onChange(of: followStore.followCheck) { _ in
            Task {
                await fetchSearchResults()
            }
        }
    }
    
    //searchUserLists에 영향? 주는 코드
    var searchUserResult: some View {
        ForEach(searchStore.searchUserLists, id: \.self) { user in
            NavigationLink {
                OtherPageView(user: user)
            } label: {
                SearchUserCellView(user: user)
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


