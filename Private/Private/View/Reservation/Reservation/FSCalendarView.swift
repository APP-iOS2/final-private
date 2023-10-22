//
//  CalendarView.swift
//  Private
//
//  Created by 박성훈 on 10/12/23.
//

import SwiftUI
import UIKit
import FSCalendar

struct FSCalendarView: UIViewRepresentable {
    @EnvironmentObject var calendarData: CalendarData
    
    let calendar = FSCalendar()
    let regularHoliday: [Int]
    let temporaryHoliday: [Date]
    var publicHolidays: [[String:Any]]
    
    
    // MARK: - 메소드
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        // 언어 한국어로 변경
        calendar.locale = Locale(identifier: "ko_KR")
        
        
        // MARK: - 상단 헤더 뷰
        calendar.appearance.headerTitleColor = .clear
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0  //헤더 좌,우측 흐릿한 글씨 삭제
        calendar.headerHeight = 0  // 헤더 없앰(헤더를 따로 만들기 위함)
        //        calendar.appearance.headerDateFormat = "YYYY년 M월"
        
        //MARK: -캘린더(날짜 부분) 관련
        //        calendar.backgroundColor = .white // 배경색
        calendar.appearance.weekdayTextColor = UIColor(named: "AccentColor") //요일(월,화,수..) 글씨 색
        calendar.appearance.selectionColor = UIColor(named: "AccentColor") //선택 된 날의 동그라미 색
        calendar.appearance.titleDefaultColor = UIColor.label  //기본 날짜 색
        calendar.placeholderType = .none  // 해당 달의 날만 보여줌
        calendar.select(calendarData.selectedDate)  // 선택한 날짜
        //        calendar.appearance.titleSelectionColor = UIColor(named: "AccentColor") // 선택된 날의 컬러 설정
        
        //MARK: -오늘 날짜(Today) 관련
        calendar.appearance.titleTodayColor = UIColor.label //Today에 표시되는 특정 글자색
        calendar.appearance.todayColor = .clear //Today에 표시되는 선택 전 동그라미 색
        calendar.appearance.todaySelectionColor = .none  //Today에 표시되는 선택
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // 선택한 날짜를 업데이트
        uiView.setCurrentPage(calendarData.currentPage, animated: true)  // 페이지 넘기는 버튼 눌렀을 때
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)  // self - FSCalendarView 인스턴스를 의미
    }
    
    
    
    // MARK: - Cooidinator
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: FSCalendarView
        
        init(_ parent: FSCalendarView) {
            self.parent = parent
        }
        
        
        // MARK: - FSCalendarDelegateAppearance 메소드
        // 타이틀 컬러 변경 메소드
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            let day = Calendar.current.component(.weekday, from: date) - 1
            
            // Date()로 하면 시간이 계속 바뀌기 때문에 0시를 기준으로 하기 위함
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            dateComponents.hour = 0
            dateComponents.minute = 0
            dateComponents.second = 0
            
            let weekday = calendar.component(.weekday, from: date) // 해당 날짜의 요일을 가져옴 (1: 일요일, 2: 월요일, ...)
            let regularHolidays: [Int] = parent.regularHoliday
            
            let today = calendar.date(from: dateComponents) ?? Date()
            let nextYear = Date().addingTimeInterval((60 * 60 * 24) * 365)
            let temporaryHoliday: [Date] = parent.temporaryHoliday
            let publicHolidays = parent.publicHolidays
            
            if date < today || date > nextYear {  // 달력에 있는 날들이 과거이거나 1년 후보다 미래일 때
                return UIColor.secondaryLabel
            }
            
            // 휴일 - 기본 빨간색 / 과거 or 휴무일 - secondaryLabel
            for holiday in publicHolidays {
                if let holidayDate = holiday["date"] as? Date {
                    if regularHolidays.contains(weekday) || temporaryHoliday.contains(where: { calendar.isDate(date, inSameDayAs: $0) }) {
                        return UIColor.secondaryLabel
                    } else if calendar.isDate(date, inSameDayAs: holidayDate) {
                        return .systemRed
                    }
                }
            }
            
            if regularHolidays.contains(weekday) || temporaryHoliday.contains(where: { calendar.isDate(date, inSameDayAs: $0) }) {
                return UIColor.secondaryLabel
            } else if calendar.shortWeekdaySymbols[day] == "Sun" { // 국경일에도 포함되도록
                return .systemRed
            } else  {
                return .label
            }
        }
        
        //날짜 밑에 문자열을 표시
        // 서브타이틀 색의 기본값을 적용 안해주면 다 음영처리 되어서 나옴,
        // 서브타이틀의 기본값을 적용하면, 다른 색들의 색을 변경하려고 해도 기본값으로 나옴 ...
        func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            calendar.appearance.subtitleDefaultColor = UIColor.label
            
            let temporaryHoliday: [Date] = parent.temporaryHoliday
            
            // 공휴일 색상은 빨간색으로 만듦
            for holiday in parent.publicHolidays {
                if let holidayDate = holiday["date"] as? Date {
                    if Calendar.current.isDate(date, inSameDayAs: holidayDate) {
                        //                        return holiday["title"] as? String
                        let subtitleText = holiday["title"] as? String
                        let attributes: [NSAttributedString.Key : Any] = [
                            .foregroundColor: UIColor.systemRed, // 빨간색으로 변경
                            .font: UIFont.systemFont(ofSize: 12)
                        ]
                        let attributedSubtitle = NSAttributedString(string: subtitleText ?? "", attributes: attributes)
                        return attributedSubtitle.string
                    }
                }
            }
            
            if temporaryHoliday.contains(where: { Calendar.current.isDate(date, inSameDayAs: $0) }) {
                //                return "임시휴무"
                let subtitleText = "임시휴무"
                let attributes: [NSAttributedString.Key : Any] = [
                    .foregroundColor: UIColor.secondaryLabel,
                    .font: UIFont.systemFont(ofSize: 12)
                ]
                let attributedSubtitle = NSAttributedString(string: subtitleText, attributes: attributes)
                return attributedSubtitle.string
            }
            
            if Calendar.current.isDateInToday(date) {
                return "오늘"
            }
            return nil
        }
        
        // MARK: - Delegate
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: date) // 해당 날짜의 요일을 가져옴 (1: 일요일, 2: 월요일, ...)
            let regularHolidays: [Int] = parent.regularHoliday
            let temporaryHoliday: [Date] = parent.temporaryHoliday
            
            print("캘린더 데이트 - \(date)")
            
            if regularHolidays.contains(weekday) || temporaryHoliday.contains(where: { calendar.isDate(date, inSameDayAs: $0) }){
                print("temporaryHoliday: \(temporaryHoliday)")
                return false
            } else {
                return true
            }
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.calendarData.selectedDate = date
        }
        
        // 보라색 에러 - 메인이 아닌 다른 곳에서 바꾸면 이런 문제가 발생..
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            DispatchQueue.main.async {  // 호출하는 버튼은 main에서 돌아감 -> 여기도 메인으로 돌아가게 해줘야 함
                self.parent.calendarData.currentPage = calendar.currentPage
                self.parent.calendarData.titleOfMonth = calendar.currentPage
            }
        }
        
        // 선택 가능한 최대 날짜 - 1년 후까지
        func maximumDate(for calendar: FSCalendar) -> Date {
            return Date().addingTimeInterval((60 * 60 * 24) * 365)  // 1년 후까지
        }
        
        // 선택 가능한 최소 날짜 - 오늘
        func minimumDate(for calendar: FSCalendar) -> Date {
            return Date()
        }
        
    }
}
