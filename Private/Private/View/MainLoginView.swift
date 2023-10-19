//
//  MainLoginView.swift
//  Private
//
//  Created by 변상우 on 2023/09/18.
//

import SwiftUI
import Firebase
import GoogleSignInSwift

struct MainLoginView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        VStack {
            Spacer()
            Text("Private.")
                .font(.pretendardBold28)
                .foregroundStyle(.primary)
            
            Spacer()
            HStack {
                ZStack {
                    Divider()
                        .foregroundStyle(.primary)
                    Text("간편 로그인")
                        .font(.pretendardBold14)
                        .foregroundStyle(.primary)
                        .padding()
                        .background(Color.tabColor)
                }
            }
            .padding()
            
            GoogleSignInButton {
                authStore.signInGoogle()
            }
            .frame(width: .screenWidth * 0.9)
            
            Button {
//                authStore.openKakaoService()
            } label: {
                Image("KakaoLogin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .screenWidth * 0.9)
            }
            .frame(width: .screenWidth * 0.9)
            
            Spacer()
        }
        .onDisappear {
            userStore.fetchCurrentUser(userEmail: (authStore.currentUser?.email)!)
        }
    }
}

struct MainLoginView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoginView()
    }
}
