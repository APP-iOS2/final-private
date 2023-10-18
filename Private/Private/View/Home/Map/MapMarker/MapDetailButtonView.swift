//
//  MapDetailButtonView.swift
//  Private
//
//  Created by yeon I on 2023/09/26.
//
import SwiftUI

struct MapDetailButtonView: View {
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                //ChatRoomView()
            } label: {
                Image(systemName: "paperplane")
                    .font(.pretendardRegular14)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(isHovered ? Color.yellow : Color.subGrayColor)
                    .cornerRadius(30)
                    .shadow(color: isHovered ? Color.black.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 10) // 그림자 효과 추가
                    .scaleEffect(isHovered ? 1.05 : 1) // 스케일 효과 추가
            }
            .onHover {hovering in
                withAnimation {
                    self.isHovered = hovering
                }
            }
        }
    }
}

struct MapDetailButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MapDetailButtonView()
    }
}
