//
//  SearchUserCellView.swift
//  Private
//
//  Created by 박범수 on 2023/09/22.
//

import SwiftUI

struct SearchUserCellView: View {
    @EnvironmentObject private var followStore: FollowStore
    var user: User
//    @State private var followCheck = false
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.profileImageURL)) { image in
                image
                    .resizable()
                    .frame(width: 44, height: 44)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 44, height: 44)
            .padding()
            Text(user.nickname)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()

            FollowButton(user: user, followingCount: $followStore.following, followersCount: $followStore.followers, followCheck: $followStore.followCheck)
                .font(.pretendardBold18)
                .frame(width: .screenWidth * 0.2, height: 12)
                .padding(12)
                .foregroundColor(.black)
                .background(followStore.followCheck ? Color("AccentColor") : Color.white)
                .cornerRadius(18)
        }
    }
}

struct SearchUserCellView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserCellView(user: User())
            .environmentObject(FollowStore())
    }
}

