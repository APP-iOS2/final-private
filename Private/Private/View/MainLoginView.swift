//
//  MainLoginView.swift
//  Private
//
//  Created by 변상우 on 2023/09/18.
//

import SwiftUI
import Firebase

struct MainLoginView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        VStack {
            Button {
                authStore.signInGoogle()
            } label: {
                Text("구글 로그인")
            }
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
