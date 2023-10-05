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
            Spacer()
            
            Text("Private")
                .font(.pretendardBold28)
                .foregroundStyle(.primary)
            
            Spacer()
            
            TextField("닉네임을 입력하세요", text: $nickName)
                .textInputAutocapitalization(.never) // 첫글자 대문자 비활성화
                .disableAutocorrection(true) // 자동수정 비활성화
                .padding(10)
                .padding(.leading, 5)
                .background(Color.lightGrayColor)
                .cornerRadius(20)
            
            TextField("휴대폰 번호를 입력하세요", text: $phoneNumber)
                .textInputAutocapitalization(.never) // 첫글자 대문자 비활성화
                .disableAutocorrection(true) // 자동수정 비활성화
                .padding(10)
                .padding(.leading, 5)
                .background(Color.lightGrayColor)
                .cornerRadius(20)
            
            Button {
                userStore.user.nickname = nickName
                userStore.user.phoneNumber = phoneNumber
                
                userStore.updateUser(user: userStore.user)
            } label: {
                Text("정보입력 완료하기")
                    .foregroundStyle(.primary)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Spacer()

        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
