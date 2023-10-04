//
//  String+.swift
//  Private
//
//  Created by 박성훈 on 2023/09/27.
//

import Foundation

extension String {
    
    /// Date 타입을 String타입으로 변환
    func stringFromDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: now)
    }
}
