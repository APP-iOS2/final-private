//
//  UserInfoModifyView.swift
//  Private
//
//  Created by 주진형 on 2023/09/27.
//

import SwiftUI

struct UserInfoModifyView: View {
    @EnvironmentObject private var userStore: UserStore
    @Binding var isModify: Bool
    var body: some View {
        NavigationStack {
            Text("정보변경")
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(userStore.user.nickname))
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isModify = false
                } label: {
                    Text("취소")
                        .font(.pretendardBold14)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct UserInfoModifyView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoModifyView(isModify: .constant(true)).environmentObject(UserStore())
    }
}
