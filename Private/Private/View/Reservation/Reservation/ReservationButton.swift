//
//  MyButton.swift
//  Private
//
//  Created by 박성훈 on 10/11/23.
//

import SwiftUI

struct ReservationButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Text(self.text)
                .font(.pretendardBold18)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .background(Color.privateColor)
        .cornerRadius(12)
    }
}

struct MyButton_Previews: PreviewProvider {
    let action: () -> Void = {
        print("액션 클로저가 호출되었습니다.")
    }
    
    static var previews: some View {
        ReservationButton(text: "예약하기") {
            print("프리뷰")
        }
    }
}
