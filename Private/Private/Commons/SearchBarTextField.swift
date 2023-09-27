//
//  SearchBarTextField.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI

struct SearchBarTextField: View {
    @Binding var text: String
    
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never) // 첫글자 대문자 비활성화
                .disableAutocorrection(true) // 자동수정 비활성화
                .padding(10)
                .background(Color.subGrayColor)
                .cornerRadius(10)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.gray)
                        .opacity(text.isEmpty ? 0 : 1)
                }
                .padding(.trailing, 8)
            }
        }
        .frame(width: .screenWidth * 0.9, height: 40)
    }
}
