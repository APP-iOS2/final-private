//
//  SearchPageView.swift
//  Private
//
//  Created by 박범수 on 10/17/23.
//

import SwiftUI

struct SearchPageView: View {
    
    @ObservedObject var searchStore: SearchStore
    @Binding var searchTerm: String
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading) {
                Text("최근 찾은 사용자")
                    .font(.pretendardBold18)
                    .padding()
                
                Divider().padding()
            }
            
            if !searchStore.searchUserLists.isEmpty {
                ForEach(searchStore.searchUserLists, id: \.self) { user in
                    NavigationLink {
                        LazyView(ProfileView(user: user))
                    } label: {
                        UserCellView(user: user)
                    }
                }
                .padding(.bottom, 8)
            } else {
                Text("최근 검색 기록이 없습니다")
                    .foregroundColor(.secondary)
            }
        }
    }
}
