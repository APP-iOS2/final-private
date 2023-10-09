//
//  Modifiers.swift
//  Private
//
//  Created by 변상우 on 2023/09/25.
//

import SwiftUI

struct BottomBorder: ViewModifier {
    
    let showBorder: Bool
    
    func body(content: Content) -> some View {
        Group {
            if showBorder {
                content.overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 2)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                    , alignment: .bottom
                )
            } else {
                content
            }
        }
    }
}
