//
//  FollowButton.swift
//  Private
//
//  Created by 박범수 on 10/6/23.
// 버튼 쪼개서 역활 분리 !!
//

import SwiftUI

struct FollowButton: View {
    @ObservedObject var followStore: FollowStore
    var isFollowed : Bool { return followStore.user.isFollowed ?? false}
    @State private var showEditProfile = false
    
    var body: some View {
            HStack {
                Button(action: {isFollowed ? followStore.unfollow() : followStore.follow() }, label: {
                    Text(isFollowed ? "팔로잉" : "팔로우") // 삼항연산 사용
                        .font(.pretendardSemiBold14)
                        .frame(width: .screenWidth * 0.2, height: 12)
                        .foregroundColor(.black)
                        .background(isFollowed ? Color("AccentColor") : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.gray, lineWidth: isFollowed ? 1 : 0)
                        )
                }).cornerRadius(3)
            }
        }
    }



