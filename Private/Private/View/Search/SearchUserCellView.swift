//
//  SearchUserCellView.swift
//  Private
//
//  Created by 박범수 on 2023/09/22.
//

import SwiftUI

struct SearchUserCellView: View {
    @EnvironmentObject private var followStore: FollowStore
    var user:User
    
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.profileImageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            }placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 44, height: 44)
            
            Button {
                followStore.manageFollow(userId: user.id, followCheck: followStore.followCheck)
            } label: {
                Text("팔로우")
            }
            .background(followStore.followCheck ? Color.primary : Color.subGrayColor)

        }
    }
}
