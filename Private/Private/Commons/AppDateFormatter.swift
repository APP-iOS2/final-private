//
//  AppDateFormatter.swift
//  Private
//
//  Created by H on 2023/10/06.
//

import Foundation

class AppDateFormatter {
    
    static let shared = AppDateFormatter()
    
    private init() {}
    
    private let fullDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .full
        df.timeStyle = .none
        df.timeZone = TimeZone(abbreviation: "KST")
        df.locale = Locale(identifier: "ko_KR")
        
        return df
    }()
    
    func fullDateString(from date: Date) -> String {
        return fullDateFormatter.string(from: date)
    }
    
    private let dayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        df.timeZone = TimeZone(abbreviation: "KST")
        df.locale = Locale(identifier: "ko_KR")
        
        return df
    }()
    
    func dayString(from date: Date) -> String {
        return dayFormatter.string(from: date)
    }
}
