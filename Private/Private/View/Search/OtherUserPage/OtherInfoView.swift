//
//  OtherInfoView.swift
//  Private
//
//  Created by 박범수 on 10/5/23.
//

import SwiftUI
import Kingfisher

struct OtherInfoView: View {
    
    @EnvironmentObject private var followStore: FollowStore
    
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
                            .frame(width: .screenWidth*0.23,height: 80)
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
                Text(user.nickname).font(.pretendardBold24)
            }.padding([.top, .trailing], 14)
            VStack {
                HStack {
                    VStack {
                        Text("\(user.myFeed.count)")
                            .font(.pretendardBold18)
                            .padding(.bottom, 5.0)
                        Text("게시글")
                            .font(.pretendardBold14)
                    }
                    .padding(.trailing,19.0 )
                    NavigationLink {
                        MyFollowerFollowingView(viewNumber: 0)
                    } label: {
                        VStack {
                            Text("\(followStore.followers)")
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
                        MyFollowerFollowingView(viewNumber: 1)
                    } label: {
                        VStack {
                            Text("\(followStore.following)")
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
                
                FollowButton(user: user, followingCount: $followStore.following, followersCount: $followStore.followers)
                        .font(.pretendardRegular14)
                        .frame(width: .screenWidth*0.5, height: 32)
                        .background(followStore.followCheck ? Color("AccentColor") : Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
            }
            .padding(.top, 40.0)
        }
    }
}

struct OtherInfoView_Previews: PreviewProvider {
    static var previews: some View {
        OtherInfoView(user: User())
    }
}
