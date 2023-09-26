//
//  MapReviewEmptyView.swift
//  Private
//
//  Created by yeon I on 2023/09/26.
//

import SwiftUI

struct NoReviewView: View {
    var visitorName: String

    var body: some View {
        VStack(spacing: 20) {
            Text("이런, 아무도 리뷰를 안썼네요?")
                .font(.pretendardBold28)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            Text("\(visitorName) 님이 친구들에게 추천할 맛집의 영광스러운 첫 리뷰를 써주세요!")
                .font(.pretendardMedium16)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(Color.white)
    }
}
struct NoReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NoReviewView(visitorName: "방문자")
    }
}
