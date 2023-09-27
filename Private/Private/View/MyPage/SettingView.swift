//
//  SettingView.swift
//  Private
//
//  Created by 주진형 on 2023/09/26.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var authStore: AuthStore
    
    var backButton : some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
        }
    } // custom backbutton
    var body: some View {
        NavigationStack {
            List {
                Section (content: {
                    Toggle(isOn: .constant(true), label: {
                        Text("모든알림")
                            .font(.pretendardBold18)
                    })
                }, header: {
                    Text("알림")
                        .font(.pretendardRegular12)
                })
                Section (content: {
                    HStack {
                        VStack {
                            Text("v1.0.0")
                                .font(.pretendardBold18)
                        }
                        Spacer()
                        Text("최신 버전입니다.")
                            .font(.pretendardRegular12)
                    }
                    
                }, header: {
                    Text("현재버전")
                        .font(.pretendardRegular12)
                })
                Section (content: {
                    Button{
                        print("로그아웃")
                        authStore.signOutGoogle()
                    } label: {
                        HStack {
                            Text("로그아웃")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Button{
                        print("계정삭제")
                    } label: {
                        HStack {
                            Text("계정삭제")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundColor(.red)
                    
                }, header: {
                    Text("계정관리")
                        .font(.pretendardRegular12)
                })
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
