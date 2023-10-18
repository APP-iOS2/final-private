//
//  UserStatView.swift
//  Private
//
//  Created by 박범수 on 10/17/23.
//

import SwiftUI

struct UserStatView: View {
    
    let value: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.pretendardBold18)
            Text(title)
                .font(.pretendardBold14).frame(width: 80, alignment: .center)
        }.frame(width: 80, alignment: .center) // 요소 간 스태틱한 width를 부여
    }
}
struct UserStatView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatView(value: 1, title: "Posts")
    }
}
