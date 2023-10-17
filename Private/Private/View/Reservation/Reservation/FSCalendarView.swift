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
    @Binding var currentPage: Date
    @Binding var selectedDate: Date
    @Binding var calendarTitle: Date
    
    let calendar = FSCalendar()
    // 가져와야 할 데이터 - 정기 휴무일
    // 임시 휴무일
    let regularHoliday: [Int]
    let temporaryHoliday: [Date]
    
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
        //        calendar.appearance.titleSelectionColor = UIColor(named: "AccentColor") // 선택된 날의 컬러 설정
        
        //MARK: -오늘 날짜(Today) 관련
        calendar.appearance.titleTodayColor = UIColor.label //Today에 표시되는 특정 글자색
        calendar.appearance.todayColor = .clear //Today에 표시되는 선택 전 동그라미 색
        calendar.appearance.todaySelectionColor = .none  //Today에 표시되는 선택
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // 선택한 날짜를 업데이트
        uiView.setCurrentPage(currentPage, animated: true)  // 버튼 눌렀을 때
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)  // self - FSCalendarView 인스턴스를 의미
    }
    
    
    
    // MARK: - Cooidinator
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: FSCalendarView
        
        init(_ parent: FSCalendarView) {  // 초기화 방법
            self.parent = parent
        }
        
        
        // MARK: - FSCalendarDelegateAppearance 메소드
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

            if date < today || date > nextYear {
                return UIColor.secondaryLabel
            } else if regularHolidays.contains(weekday) || temporaryHoliday.contains(date) {
                return UIColor.secondaryLabel
            } else if Calendar.current.shortWeekdaySymbols[day] == "Sun" || Calendar.current.shortWeekdaySymbols[day] == "일" {
                return .systemRed
            } else  {
                return .label
            }
            
        }
        
        //날짜 밑에 문자열을 표시
        func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            let temporaryHoliday: [Date] = parent.temporaryHoliday

            if temporaryHoliday.contains(date) {
                return "임시휴무"
            } 
            else if Calendar.current.isDateInToday(date) {
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

            print("temporaryHoliday: \(parent.temporaryHoliday) ==========")
            print("regularHolidays: \(parent.regularHoliday) ==========")
            // 요일이 휴일로 설정된 요일 중 하나인 경우 선택 불가능하도록 만듦
            if regularHolidays.contains(weekday) || temporaryHoliday.contains(date) {
                return false
            }
            
            return true

        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            parent.currentPage = calendar.currentPage
            parent.calendarTitle = calendar.currentPage
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
