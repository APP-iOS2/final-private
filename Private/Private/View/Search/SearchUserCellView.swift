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

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.profileImageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
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
            
            Button {
                followStore.manageFollow(userId: user.id, followCheck: followStore.followCheck)
            } label: {
                Text(followStore.followCheck ? "팔로잉" : "팔로우")
                    .font(.pretendardBold18)
                    .padding(12)
                    .foregroundColor(.black)
                    .background(followStore.followCheck ? Color("AccentColor") : Color.white)
                    .cornerRadius(18)
            }
        }
    }
}

struct SearchUserCellView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserCellView(user: User())
            .environmentObject(FollowStore())
    }
}
