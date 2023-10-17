//
//  FollowButton.swift
//  Private
//
//  Created by 박범수 on 10/6/23.
// 버튼 쪼개서 역활 분리 !!
//

import SwiftUI

struct FollowButton: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var followStore: FollowStore

    var user:User
    
    @State private var backgroundColor = Color.white
    

    var body: some View {
        Button {
            followStore.manageFollow(userId: user.nickname, myNickName: userStore.user.nickname, userEmail: user.email)
            followStore.followCheck.toggle()
        } label: {
            Text((followStore.followCheck) ? "팔로잉" : "팔로우")
        }
        .background((followStore.followCheck) ? Color("AccentColor") : Color.white)
    }
}
