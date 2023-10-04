//
//  MapToChatRoomView.swift
//  Private
//
//  Created by yeon I on 2023/09/26.
//

import SwiftUI

struct MapToChatRoomView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MapToChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        MapToChatRoomView()
    }
}

SendMessageTextField(text: $message, placeholder: "메시지를 입력하세요") {
    sendMessage()
}
}

func sendMessage() {
chatRoomStore.messageList.append(Message(sender: "나", content: message, timestamp: Date().timeIntervalSince1970))
}
