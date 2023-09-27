//
//  SignUpView.swift
//  Private
//
//  Created by 변상우 on 2023/09/27.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var nickName: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        VStack {
            TextField("닉네임을 입력하세요", text: $nickName)
            TextField("휴대폰 번호를 입력하세요", text: $phoneNumber)
            
            Button {
                userStore.updateUser(user: User(email: userStore.user.email, name: userStore.user.name, nickname: nickName, phoneNumber: phoneNumber, profileImageURL: "", follower: [], following: [], myFeed: [], savedFeed: [], bookmark: [], chattingRoom: [], myReservation: []))
            } label: {
                Text("정보입력 완료하기")
            }
            
            Button {
                authStore.signOutGoogle()
            } label: {
                Text("구글 아이디 로그아웃")
            }

        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
