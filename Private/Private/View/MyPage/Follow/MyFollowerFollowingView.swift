//
//  MyFollowerFollowingView.swift
//  Private
//
//  Created by 주진형 on 2023/10/04.
//

import SwiftUI

struct MyFollowerFollowingView: View {
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var followStore: FollowStore
    let user: User
    var followerList : [String]
    var followingList : [String]
    @State var viewNumber: Int
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                Button {
                    viewNumber = 0
                } label: {
                    HStack {
                        Text("\(followerList.count)")
                        Text("팔로워")
                    }
                    .font(.pretendardSemiBold16)
                    .padding(.bottom, 15)
                    .foregroundColor(.primary)
                    .modifier(BottomBorder(showBorder: viewNumber == 0))
                }
                Spacer()
                Button {
                    viewNumber = 1
                } label: {
                    HStack {
                        Text("\(followingList.count)")
                        Text("팔로잉")
                    }
                    .font(.pretendardSemiBold16)
                    .padding(.bottom, 15)
                    .foregroundColor(.primary)
                    .modifier(BottomBorder(showBorder: viewNumber == 1))
                }
                Spacer()
            }
            .padding(.bottom, 10)
            TabView (selection: $viewNumber) {
                MyFollowerView(user: user, followerList: followerList).tag(0)
                MyFollowingView(user: user, followingList: followingList).tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
        }
        .navigationTitle("\(user.nickname)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            //followStore.fetchFollowerFollowingList(user.email)
        }
    }
}

struct MyFollowerFollowingView_Previews: PreviewProvider {
    static var previews: some View {
        MyFollowerFollowingView(user: User(), followerList: [""], followingList: [""], viewNumber:0).environmentObject(UserStore())
    }
}
