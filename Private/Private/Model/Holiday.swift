//
//  Holiday.swift
//  Private
//
//  Created by 박성훈 on 10/16/23.
//

import Foundation

// MARK: - HolidayData
struct HolidayData: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let items: Items
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// Struct - Call by value -> 새로운 객체를 만듦 / 상속 불가능
// Class - Call by reference -> 참조 / 상속 가능
/*
 Json형식으로 받아온 구조체를 변환하여 우리가 쓸 수 있는 형식으로 바꿔야 함
 
 FSCalendar에서 활용하기 위해 date로 비교를 해야 함
 Item의 isHoliday == .y 일 때만 해당 되도록 해야 함
 1. 공휴일에 해당하는 날들의 titleColor를 UIColor.systemRed로 만들어줘야 함
 2. 공휴일에 해당하는 날들의 subTitle을 Item의 dateName으로 맞춰줘야 함
 
 방법 1.
 애초에 활용하기 좋게 바꾼다.
 
 Int로 되어있는 날을 Date 형식으로 바꿈
 
 필요한 데이터인 dateName과 locdate를 이용하여 배열/딕셔너리 or 튜플 형태로 만듦
 배열로 만들면 같이 넣으면 되긴 하지만, 완벽히 매칭된다는 보장이 없음
 딕셔너리로 하면 여러 해로 넣었을 때 혹은, 추석같이 연휴가 길 때 키값이 중복된다. -> 키를 날짜로 해야하나
 
 
 
 방법 2.
 FSCalendar에 메소드를 만들어 거기서 최적화한다.
 
 */

// MARK: - Item
struct Item: Codable {
    let dateName: String
    let isHoliday: IsHoliday
    let locdate: Int
    
    var holidayDate: Date {
        let calendar = Calendar.current
        
        //        guard let locdate else { return Date() }
        let year = locdate / 10000
        let month = (locdate / 100) % 100
        let day = locdate % 100
        
        // DateComponents를 사용하여 Date로 변환
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        if let date = calendar.date(from: dateComponents) {
            return date
        } else {
            print("공휴일 가져오기 실패")
            return Date()
        }
    }
    
    // publicHolidays에 맞게 딕셔너리를 반환하는 메서드
    func toDictionary() -> [String: Any] {
        return [
            "date": holidayDate,
            "title": dateName
        ]
    }
}

enum IsHoliday: String, Codable {
    case n = "N"
    case y = "Y"
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}

struct PublicHoliday: Codable {
    let title: String
    let date: Date
}
