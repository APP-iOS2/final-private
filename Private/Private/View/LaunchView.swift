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
                }
                .onAppear {
                    if let email = authStore.currentUser?.email {
                        userStore.fetchCurrentUser(userEmail: email)
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
