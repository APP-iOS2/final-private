//
//  LaunchView.swift
//  Private
//
//  Created by 변상우 on 2023/09/18.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var isActive = false
    @State private var isloading = true
    
    var body: some View {
        if isActive {
            /// 로그인 한 유저가 있으면 MainTabView로 이동
            /// 로그인 한 유저가 없으면 MainLoginView로 이동
            if authStore.currentUser != nil {
                 MainTabView()
             } else {
                 MainLoginView()
             }
        } else {
            if isloading {
                VStack {
                    Text("Launch View")
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                            self.isloading.toggle()
                        }
                    }
                    if let userEmail = authStore.currentUser?.email {
                        userStore.fetchCurrentUser(userEmail: userEmail)
                    }
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
