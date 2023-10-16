//
//  Message.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import Foundation

struct Message: Hashable {
    let sender: String // 보낸 사람의 이름 또는 ID
    let content: String // 메시지 내용
    let timestamp: Double // 메시지를 보낸 시간
    
    init?(document: [String: Any]) {
        guard
            let sender = document["sender"] as? String,
            let content = document["content"] as? String,
            let timestamp = document["timestamp"] as? Double
            // 다른 필드들에 대한 추출 작업을 추가합니다.
        else {
            return nil // 필수 필드가 없을 경우 초기화를 실패시킵니다.
        }
        
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
    }
    
    init(sender: String, content: String, timestamp: Double) {
            self.sender = sender
            self.content = content
            self.timestamp = timestamp
        }
}
