//
//  MyFollowingView.swift
//  Private
//
//  Created by 주진형 on 2023/10/04.
//

import SwiftUI

struct MyFollowingView: View {
    @EnvironmentObject var userStore: UserStore
    var body: some View {
        ScrollView {
            ForEach(userStore.user.following, id:\.self) { following in
                HStack {
                    Text("\(following)")
                        .foregroundColor(.primary)
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("팔로우")
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .font(.pretendardBold14)
                            .foregroundColor(.black)
                            .background(Color.primary)
                            .cornerRadius(20)
                        
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
                Divider()
                    .background(Color.primary)
                    .frame(width: .screenWidth*0.9)
            }
        }
    }
}

struct MyFollowingView_Previews: PreviewProvider {
    static var previews: some View {
        MyFollowingView().environmentObject(UserStore())
    }
}
