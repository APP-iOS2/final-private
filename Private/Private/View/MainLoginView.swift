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
    
    var body: some View {
        VStack {
            Button {
                authStore.signInGoogle()
            } label: {
                Text("구글 로그인")
            }

        }
    }
}

struct MainLoginView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoginView()
    }
}
