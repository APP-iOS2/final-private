//
//  ToastMessageView.swift
//  Private
//
//  Created by 변상우 on 10/20/23.
//

import SwiftUI

struct ToastMessageView: View {
    var message: String
    
    var body: some View {
        Text("\(message)")
            .font(.pretendardMedium16)
            .foregroundColor(.white)
            .frame(width: .screenWidth * 0.8, height: 50)
            .background(Color.darkGrayColor)
            .cornerRadius(30)
    }
}
