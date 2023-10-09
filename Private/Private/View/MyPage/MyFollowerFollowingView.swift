//
//  MyFollowerFollowingView.swift
//  Private
//
//  Created by 주진형 on 2023/10/04.
//

import SwiftUI

struct MyFollowerFollowingView: View {
    @EnvironmentObject private var userStore: UserStore
    @State var viewNumber: Int
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                Button {
                    viewNumber = 0
                } label: {
                    HStack {
                        Text("\(userStore.user.follower.count)")
                        Text("팔로워")
                    }
                    .padding(.bottom, 15)
                    .foregroundColor(.primary)
                    .modifier(BottomBorder(showBorder: viewNumber == 0))
                }
                Spacer()
                Button {
                    viewNumber = 1
                } label: {
                    HStack {
                        Text("\(userStore.user.following.count)")
                        Text("팔로잉")
                    }
                    .padding(.bottom, 15)
                    .foregroundColor(.primary)
                    .modifier(BottomBorder(showBorder: viewNumber == 1))
                }
                Spacer()
            }
            .padding(.bottom, 10)
            switch viewNumber {
            case 0:
                MyFollowerView()
            case 1:
                MyFollowingView()
            default:
                MyFollowerView()
            }
        }
        .navigationTitle("\(userStore.user.nickname)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MyFollowerFollowingView_Previews: PreviewProvider {
    static var previews: some View {
        MyFollowerFollowingView(viewNumber: 0).environmentObject(UserStore())
    }
}
