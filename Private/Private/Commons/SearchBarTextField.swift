//
//  SearchBarTextField.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI

struct SearchBarTextField: View {

    @Binding var text: String
    @Binding var isEditing: Bool
    
    var placeholder: String
     
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never) // 첫글자 대문자 비활성화
                    .disableAutocorrection(true) // 자동수정 비활성화
                
            }
            .padding(10)
            .background(Color.subGrayColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemFill), lineWidth: 1)
            )
                .onTapGesture {
                    isEditing = true
                }
            if isEditing {
                Button(action: {
                    isEditing = false
                    text = ""
                    hideKeyboard()
                }, label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                })
                    .padding(.trailing, 8)
                    .transition(.move(edge: .trailing))
            }
        }
        .background(Color.subGrayColor)
        .cornerRadius(10)
        .frame(width: .screenWidth * 0.9, height: 40)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarTextField(text: .constant("Text"), isEditing: .constant(false), placeholder: "")
    }
}
