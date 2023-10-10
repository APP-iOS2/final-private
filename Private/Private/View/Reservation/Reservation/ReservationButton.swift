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
                .frame(maxWidth: .infinity)
                .padding()
        }
        .background(Color("AccentColor"))
        .cornerRadius(12)
    }
}

//struct MyButton_Previews: PreviewProvider {
//    static var previews: some View {
//        MyButton(action: performAction { print("버튼 눌림")}, text: "예약하기")
//    }
//}
