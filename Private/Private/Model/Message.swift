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
}
