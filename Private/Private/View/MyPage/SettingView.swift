//
//  SettingView.swift
//  Private
//
//  Created by 주진형 on 2023/09/26.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var authStore: AuthStore
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var feedStore: FeedStore
    @State private var logoutAlert = false
    @State private var deleteAuth = false
    
    var body: some View {
        NavigationStack {
            List {
                Section (content: {
                    HStack {
                        VStack {
                            Text("v1.0.0")
                                .font(.pretendardRegular16)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Text("최신 버전입니다.")
                            .font(.pretendardRegular12)
                            .foregroundColor(.primary)
                    }
                    
                }, header: {
                    Text("현재버전")
                        .font(.pretendardRegular12)
                        .foregroundColor(.primary)
                })
                Section (content: {
                    Button{
                        print("로그아웃")
                        logoutAlert = true
                    } label: {
                        HStack {
                            Text("로그아웃")
                                .font(.pretendardRegular16)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.primary)
                    .alert(isPresented: $logoutAlert) {
                        Alert(
                            title: Text("로그아웃")
                                .font(.pretendardRegular16)
                                .foregroundColor(.primary),
                            message: Text("로그아웃하시겠습니까?")
                                .font(.pretendardRegular12)
                                .foregroundColor(.primary),
                            primaryButton:.destructive(Text("로그아웃")
                                .font(.pretendardRegular12)
                                .foregroundColor(.primary), action: { platformLogout() }),
                            secondaryButton: .cancel(Text("취소")
                                .font(.pretendardRegular12)
                                .foregroundColor(.primary))
                        )
                    }
                    
                    Button{
                        deleteAuth = true
                    } label: {
                        HStack {
                            Text("회원탈퇴")
                                .font(.pretendardRegular16)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.red)
                    .alert(isPresented: $deleteAuth) {
                        Alert(
                            title: Text("회원탈퇴"),
                            message: Text("회원탈퇴 하시겠습니까?"),
                            primaryButton:.destructive(Text("회원탈퇴"), action: {
                                feedStore.deleteFeed (writerNickname: userStore.user.nickname)
                                authStore.deleteAuth (userStore.user.email)
                                userStore.deleteUser()
                                platformLogout()
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                    
                }, header: {
                    Text("계정관리")
                        .font(.pretendardRegular12)
                })
            }
            .navigationTitle("설정").font(.pretendardRegular16).foregroundColor(.primary)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .backButtonArrow()
        }
    }
    
    func platformLogout() {
        switch authStore.loginPlatform {
        case .google:
            authStore.signOutGoogle()
        case .kakao:
            authStore.handleKakaoLogout()
        case .email, .none:
            print(#function)
        default:
            print(#function)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
