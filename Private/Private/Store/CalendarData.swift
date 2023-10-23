//
//  CalendarStore.swift
//  Private
//
//  Created by 박성훈 on 10/13/23.
//

import Foundation

class CalendarData: ObservableObject {
    @Published var titleOfMonth: Date = Date()
    @Published var currentPage: Date = Date()
    @Published var selectedDate: Date = Date()  // ReservationStore에 있는걸로 사용하면 FSCalendar에서 따로 동작
    
    let sortedWeekdays = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    private let today: Date = Date()
    
    var strMonthTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self.titleOfMonth)
    }
    
    var disablePrevButton: Bool {
        let currentDate = Date()
        let calendar = Calendar.current  // 캘린더 인스턴스 생성
        
        // 현재 날짜에서 연도/월 추출
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        
        // 현재 페이지에서 연도/월 추출
        let pageYear = calendar.component(.year, from: self.currentPage)
        let pageMonth = calendar.component(.month, from: self.currentPage)
        
        if currentYear == pageYear && currentMonth == pageMonth {
            return true
        } else {
            return false
        }
    }
    
    var disableNextButton: Bool {
        let oneYearLater = Date().addingTimeInterval((60 * 60 * 24) * 365)  // 1년 후
        let calendar = Calendar.current  // 캘린더 인스턴스 생성
        
        // 현재 날짜에서 연도/월 추출
        let year = calendar.component(.year, from: oneYearLater)
        let month = calendar.component(.month, from: oneYearLater)
        
        // 현재 페이지에서 연도/월 추출
        let pageYear = calendar.component(.year, from: self.currentPage)
        let pageMonth = calendar.component(.month, from: self.currentPage)
        
        if year == pageYear && month == pageMonth {
            return true
        } else {
            return false
        }
    }
    
    // 오늘이 가게 휴일이면 선택한 날이 내일이 되도록 만듦
    func getSelectedDate(shopData: Shop) -> Date {
        var selectDate: Date = today
        
        let regularHolidayIsToday = shopData.regularHoliday.contains(AppDateFormatter.shared.dayString(from: selectDate))
        
        let temporaryHolidayIsToday = shopData.temporaryHoliday.contains { date in
            return Calendar.current.isDateInToday(date)
        }

        if regularHolidayIsToday || temporaryHolidayIsToday {
            selectDate = Date().addingTimeInterval(60 * 60 * 24)
            return selectDate
        } else {
            return selectDate

        }
        
//        if shopData.regularHoliday.contains(AppDateFormatter.shared.dayString(from: selectDate)) || shopData.temporaryHoliday.contains(where: { date in
//            return Calendar.current.isDate(date, inSameDayAs: today)
//            selectDate = Date().addingTimeInterval(60 * 60 * 24)
//            return selectDate
//        }){
////            selectDate = Date().addingTimeInterval(60 * 60 * 24)
////            return selectDate
//            return selectDate
//
//        }
//        return selectDate
    }
}
