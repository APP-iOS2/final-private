//
//  OtherInfoView.swift
//  Private
//
//  Created by 박범수 on 10/20/23.
//

import SwiftUI
import Kingfisher

struct OtherInfoView: View {
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var followStore: FollowStore
    var followerList: [String]
    var followingList: [String]
    @State var isModify: Bool = false
    
    let user:User
    var body: some View {
        HStack {
            VStack() {
                ZStack {
                    if user.profileImageURL.isEmpty {
                        Circle()
                            .frame(width: .screenWidth*0.23)
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: .screenWidth*0.23,height: .screenWidth*0.23)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    } else {
                        KFImage(URL(string: user.profileImageURL))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: .screenWidth*0.23, height: .screenWidth*0.23)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(.bottom, 1.0)
                Text(user.nickname)
                    .font(.pretendardBold24)
                    .foregroundColor(.primary)
            }.padding([.top, .trailing], 14)
            VStack {
                HStack {
                    VStack {
                        Text("\(userStore.otherFeedList.count)")
                            .font(.pretendardBold18)
                            .foregroundColor(.primary)
                            .padding(.bottom, 5.0)
                        Text("게시글")
                            .font(.pretendardBold14)
                            .foregroundColor(.primary)
                    }
                    .padding(.trailing,19.0 )
                    NavigationLink {
                        MyFollowerFollowingView(user: user, followerList: followerList, followingList: followingList, viewNumber: 0)
                    } label: {
                        VStack {
                            Text("\(followerList.count)")
                                .font(.pretendardBold18)
                                .padding(.bottom, 5.0)
                                .foregroundColor(.primary)
                            Text("팔로워")
                                .font(.pretendardBold14)
                                .foregroundColor(.primary)
                        }
                        .padding(.trailing,19.0)
                    }
                    NavigationLink {
                        MyFollowerFollowingView(user: user, followerList: followerList, followingList: followingList,viewNumber: 1)
                    } label: {
                        VStack {
                            Text("\(followingList.count)")
                                .font(.pretendardBold18)
                                .padding(.bottom, 5.0)
                                .foregroundColor(.primary)
                            Text("팔로잉")
                                .font(.pretendardBold14)
                                .foregroundColor(.primary)
                        }
                    }
                    
                }
                .padding(.bottom, 10.0)
                
                FollowButton(user: user)
                    .font(.pretendardSemiBold14)
                    .frame(width: .screenWidth*0.5, height: 32)
                    .foregroundColor(.black)
                    .background(followStore.followCheck ? Color("AccentColor") : Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: followStore.followCheck ? 0 : 1)
                    )
            }
            .padding(.top, 40.0)
        }
    }
}
