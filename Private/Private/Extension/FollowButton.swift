//
//  FollowButton.swift
//  Private
//
//  Created by 박범수 on 10/6/23.
//

import SwiftUI

struct FollowButton: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject  var followStore: FollowStore

    var user:User
    @Binding var followingCount: Int
    @Binding var followersCount: Int

    @State private var backgroundColor = Color.white

    init(user: User, followingCount: Binding<Int>, followersCount: Binding<Int>) {
        self.user = user
        self._followersCount = followersCount
        self._followingCount = followingCount
        
        // Initialize the background color state property based on the value of the followCheck property.
        if followStore.followCheck {
            backgroundColor = Color("AccentColor")
        }
    }

    func follow(){
        if !followStore.followCheck {
            followStore.follow(userId: user.nickname, myNickName: userStore.user.nickname, OtherEmail: user.email, followingCount: {
                (followingCount) in
                self.followingCount = followingCount
            }) {
                (followersCount) in
                self.followersCount = followersCount
            }

            // Update the background color state property to indicate that the user is following.
            backgroundColor = Color("AccentColor")
            followStore.followCheck = true
        } else {
            followStore.unfollow(userId: user.nickname, myNickName: userStore.user.nickname,  userEmail: user.email, followingCount: {
                (followingCount) in
                self.followingCount = followingCount
            }) {
                (followersCount) in
                self.followersCount = followersCount
            }

            // Update the background color state property to indicate that the user is not following.
            backgroundColor = Color.white
            followStore.followCheck = false
        }
    }

    private func updateBackgroundColor(followCheck: Bool) {
        if followCheck {
            backgroundColor = Color("AccentColor")
        } else {
            backgroundColor = Color.white
        }
    }

    var body: some View {
        Button(action: follow) {
            Text((followStore.followCheck) ? "팔로잉" : "팔로우")
        }
                .font(.pretendardBold18)
                .frame(width: .screenWidth * 0.2, height: 12)
                .padding(12)
                .foregroundColor(.black)
                .background(backgroundColor)
                .cornerRadius(18)
    }
}
