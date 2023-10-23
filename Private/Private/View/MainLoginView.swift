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
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                Image("SplashDark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .screenHeight * 0.35)
                
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
                
                Button {
                    authStore.signInGoogle()
                } label: {
                    HStack(alignment: .center, spacing: 0) {
                        Image("GoogleLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.leading, 15)
                        
                        HStack(alignment: .center, spacing: 0) {
                            Spacer()
                            
                            Text("구글 로그인")
                                .font(Font.pretendardBold18)
                                .foregroundStyle(.black)
                            
                            Spacer()
                        }
                        .padding(.trailing, 15)
                    }
                }
                .frame(width: .screenWidth * 0.9, height: .screenHeight * 0.06)
                .background(Color(uiColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)))
                .cornerRadius(12)
                
                Button {
                    authStore.handleKakaoLogin()
                } label: {
                    HStack(alignment: .center, spacing: 0) {
                        Image("KakaoLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.leading, 15)
                        
                        HStack(alignment: .center, spacing: 0) {
                            Spacer()
                            
                            Text("카카오톡 로그인")
                                .font(Font.pretendardBold18)
                                .foregroundStyle(.black)
                            
                            Spacer()
                        }
                        .padding(.trailing, 15)
                    }
                }
                .frame(width: .screenWidth * 0.9, height: .screenHeight * 0.06)
                .background(Color(uiColor: UIColor(red: 0.96, green: 0.87, blue: 0.20, alpha: 1.00)))
                .cornerRadius(12)
            }
            
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
