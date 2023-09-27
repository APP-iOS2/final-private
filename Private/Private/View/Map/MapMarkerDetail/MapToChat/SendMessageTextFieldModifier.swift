//
//  SendMessageTextFieldModifier.swift
//  Private
//
//  Created by yeon I on 2023/09/26.
//
import SwiftUI

struct SendMessageTextFieldModifier: ViewModifier {
    @Binding var text: String
    let placeholder: String
    let onSend: () -> Void

    func body(content: Content) -> some View {
        VStack {
            content
            HStack {
                TextField(placeholder, text: $text)
                Button(action: onSend) {
                    Image(systemName: "arrow.right.circle.fill")
                }
            }
            .padding()
        }
    }
}

extension View {
    func sendMessageTextField(text: Binding<String>, placeholder: String, onSend: @escaping () -> Void) -> some View {
        self.modifier(SendMessageTextFieldModifier(text: text, placeholder: placeholder, onSend: onSend))
    }
}
