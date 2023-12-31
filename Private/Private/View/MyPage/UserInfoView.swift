//
//  UserInfoView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI
import Kingfisher

struct UserInfoView: View {
    
    @EnvironmentObject private var userStore: UserStore
    @State var isModify: Bool = false
    var body: some View {
        HStack {
            VStack() {
                ZStack {
                    if userStore.user.profileImageURL.isEmpty {
                        Circle()
                            .frame(width: .screenWidth*0.23)
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: .screenWidth*0.23,height: .screenWidth*0.23)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    } else {
                        KFImage(URL(string: userStore.user.profileImageURL))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: .screenWidth*0.23, height: .screenWidth*0.23)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(.bottom, 1.0)
                Text(userStore.user.nickname).font(.pretendardBold24)
            }.padding([.top, .trailing], 14)
            VStack {
                HStack {
                    VStack {
                        Text("\(userStore.user.myFeed.count)")
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
                            Text("\(userStore.user.follower.count)")
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
                            Text("\(userStore.user.following.count)")
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
                Button{
                    isModify = true
                } label: {
                    Text("프로필 편집")
                        .font(.pretendardRegular14)
                        .frame(width: .screenWidth*0.5, height: 32)
                        .background(Color.subGrayColor)
                        .cornerRadius(8)
                        .foregroundColor(.primary)
                }.sheet(isPresented: $isModify, content: {
                    NavigationStack {
                        UserInfoModifyView(isModify: $isModify, mypageNickname: "")
                    }
                })
            }
            .padding(.top, 40.0)
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView().environmentObject(UserStore())
    }
}
