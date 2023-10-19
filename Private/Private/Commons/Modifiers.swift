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

struct YellowBottomBorder: ViewModifier {
    
    let showBorder: Bool
    
    func body(content: Content) -> some View {
        Group {
            if showBorder {
                content.overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 2)
                        .foregroundColor(.privateColor)
                        .padding(.top, 10)
                    , alignment: .bottom
                )
            } else {
                content
            }
        }
    }
}

struct BackButtonArrowModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .font(.pretendardSemiBold16)
                        .foregroundColor(Color.privateColor)
                }
            }
        }
    }
}

struct BackButtonXModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .font(.pretendardSemiBold16)
                        .foregroundColor(Color.privateColor)
                }
            }
        }
    }
}
