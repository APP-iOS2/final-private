//
//  UserListView.swift
//  Private
//
//  Created by 박범수 on 10/17/23.
//

import SwiftUI

struct UserListView: View {
    @ObservedObject var searchStore: SearchStore
    // searchStore: SearchStore() 형태로 초기화하면 두 번 호출되니까 이렇게 하면 안됨, SearchView.swift에서 이미 초기화
    @Binding var searchTerm: String
    
    var users: [User] {
        return searchTerm.isEmpty ? searchStore.users : searchStore.filteredUsers(searchTerm)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    NavigationLink (
                        destination: LazyView(ProfileView(user: user)),
                        label: {
                            UserCellView(user: user)
                                .padding(.leading)
                        })
                }
            }
        }
    }
}
