//
//  ChatSendView.swift
//  Private
//
//  Created by yeon I on 2023/09/26.
//

import SwiftUI

struct ChatSendView: View {
    
    @Binding var message: String
    var onSend: (String) -> Void

    var body: some View {
        VStack {
            TextField("메시지를 입력하세요", text: $message)
                .padding()
            Button("보내기") {
                onSend(message)
                message = "" // 텍스트 필드 초기화
            }
        }
    }
}

struct ChatSendView_Previews: PreviewProvider {
    @State static var previewMessage: String = ""

    static var previews: some View {
        ChatSendView(message: $previewMessage) { sentMessage in
            print("메시지가 보내졌습니다: \(sentMessage)")
        }
    }
}
