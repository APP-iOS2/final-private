//
//  UserCellView.swift
//  Private
//
//  Created by 박범수 on 2023/09/22.
//

import SwiftUI
import Kingfisher

struct UserCellView: View {
    let user: User
    
    var body: some View {
        HStack {
            KFImage(URL(string: user.profileImageURL))
                    .resizable()
                    .frame(width: 48, height: 48)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.pretendardSemiBold14)
                    
                    Text(user.nickname)
                        .font(.pretendardRegular14)
                }
            
            Spacer() // HStack 내의 가장 위에 쓰면 모든 요소가 오른쪽 정렬됨
        }
    }
}
