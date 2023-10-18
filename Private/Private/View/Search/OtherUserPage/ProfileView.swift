//
//  ProfileView.swift
//  Private
//
//  Created by 박범수 on 10/17/23.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    @ObservedObject var followStore : FollowStore // 마찬가지로 타입 선언이 아님 객체 초기화X
    
    init(user: User) {
        self.user = user
        self.followStore = FollowStore(user: user)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                OtherPage(followStore: followStore, user: user)
            }
            .padding(.top)
        }
    }
}
