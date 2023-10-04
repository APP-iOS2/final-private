//
//  UserInfoModifyView.swift
//  Private
//
//  Created by 주진형 on 2023/09/27.
//

import SwiftUI
import Kingfisher

struct UserInfoModifyView: View {
    @EnvironmentObject private var userStore: UserStore
    @Binding var isModify: Bool
    @State var mypageNickname: String
    var body: some View {
        NavigationStack {
            ZStack {
                if userStore.user.profileImageURL.isEmpty {
                    Circle()
                        .frame(width: .screenWidth*0.23)
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: .screenWidth*0.23,height: 80)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                    Image(systemName: "photo.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                } else {
                    KFImage(URL(string: userStore.user.profileImageURL))
                        .frame(width: .screenWidth*0.23)
                }
            }
            Divider()
                .background(Color.primary)
                .frame(width: .screenWidth*0.9)
                .padding([.top,.bottom],15)
            HStack {
                Text("닉네임")
                TextField("\(userStore.user.nickname)", text: $mypageNickname)
                    .padding(.leading, 5)
            }
            .padding([.leading,.trailing], 28)
            HStack {}
            HStack {}
            HStack {}
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(userStore.user.nickname))
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isModify = false
                } label: {
                    Text("취소")
                        .font(.pretendardBold14)
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    userStore.updateUser(user: User(email: userStore.user.email, name: userStore.user.name, nickname: mypageNickname, phoneNumber: userStore.user.phoneNumber, profileImageURL: userStore.user.profileImageURL, follower: userStore.user.follower, following: userStore.user.following, myFeed: userStore.user.myFeed, savedFeed: userStore.user.savedFeed, bookmark: userStore.user.bookmark, chattingRoom: userStore.user.chattingRoom, myReservation: userStore.user.myReservation))
                    isModify = false
                } label: {
                    Text("수정")
                        .font(.pretendardBold14)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct UserInfoModifyView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoModifyView(isModify: .constant(true), mypageNickname: "").environmentObject(UserStore())
    }
}
