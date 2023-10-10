//
//  FollowButton.swift
//  Private
//
//  Created by 박범수 on 10/6/23.
//

import SwiftUI

struct FollowButton: View {
    @EnvironmentObject var userStore: UserStore
    @ObservedObject  var followStore = FollowStore()
    
    var user:User
    @Binding var followingCount: Int
    @Binding var followersCount: Int
    @Binding var followCheck: Bool
    
    init(user: User, followingCount: Binding<Int>, followersCount: Binding<Int>, followCheck: Binding<Bool>) {
        
        self.user = user
        self._followCheck = followCheck
        self._followersCount = followersCount
        self._followingCount = followingCount
    }
    
    func follow(){
        if !self.followCheck {
            followStore.follow(userId: user.nickname, myNickName: userStore.user.nickname, OtherEmail: user.email, followingCount: {
                (followingCount) in
                self.followingCount = followingCount
            }) {
                (followersCount) in
                self.followersCount = followersCount
            }
            
            self.followCheck = true
        } else {
            followStore.unfollow(userId: user.nickname, myNickName: userStore.user.nickname,  userEmail: user.email, followingCount: {
                (followingCount) in
                self.followingCount = followingCount
            }) {
                (followersCount) in
                self.followersCount = followersCount
            }
            self.followCheck = false
        }
    }
    
    var body: some View {
        Button(action: follow) {
            Text((self.followCheck) ? "팔로잉" : "팔로우")
        }
    }
}


