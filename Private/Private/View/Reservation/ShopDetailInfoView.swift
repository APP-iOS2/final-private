//
//  ShopDetailInfoView.swift
//  Private
//
//  Created by H on 2023/09/26.
//

import SwiftUI

struct ShopDetailInfoView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let shopData: Shop
    let sortedWeekdays = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    Image(systemName: "text.justify.leading")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(Color.privateColor)
                        .frame(width: 20, height: 20)
                }
                .frame(width: 25, height: 25)
                
                Text("소개")
                    .font(.pretendardMedium18)
                    .foregroundStyle(Color.privateColor)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(shopData.shopInfo)
                    .lineSpacing(6)
                    .font(.pretendardBold14)
            }
            .padding(10)
            
            Divider()
            
            HStack(alignment: .center, spacing: 10) {
                ZStack {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(Color.privateColor)
                        .frame(width: 25, height: 25)
                }
                .frame(width: 25, height: 25)
                
                Text("영업 시간")
                    .font(.pretendardMedium18)
                    .foregroundStyle(Color.privateColor)
                
                Spacer()
                
                ZStack {
//                    Text("영업 전")  // 오픈 시간 전이면 영업 전, 마감 시간 이후 ~ 영업 종료
                    Text("\(isShopOpen(shopData))")
                        .font(.pretendardMedium18)
                        .foregroundStyle(Color.black)
                        .padding(10)
                }
                .background(isShopOpen(shopData) == "영업중" ? Color.privateColor : Color.subGrayColor)
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(sortedWeekdays, id: \.self) { day in
                    if let hours = shopData.weeklyBusinessHours[day] {
                        HStack(spacing: 0) {
                            Text("\(day)")
                            
                            VStack {
                                Divider()
                            }
                            .padding(.horizontal, 5)
                            
                            if shopData.regularHoliday.contains(where: { holidayString in
                                return holidayString == day
                            }) {
                                Text("정기 휴무")
                            } else {
                                ShopDetailHourTextView(startHour: hours.startHour, startMinute: hours.startMinute, endHour: hours.endHour, endMinute: hours.endMinute)
                            }
                        }
                        .font(.pretendardBold14)
                    }
                }
            }
            .padding(10)
            
            VStack(spacing: 10) {
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(shopData.temporaryHoliday.filter({ date in
                            return date >= Calendar.current.startOfDay(for: Date())
                        }), id: \.self) { day in
                            HStack(spacing: 0) {
                                Text(AppDateFormatter.shared.fullDateString(from: day))
                                    .font(.pretendardBold14)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(10)
                } label: {
                    Text("휴무일")
                        .font(.pretendardMedium18)
                        .foregroundStyle(Color.privateColor)
                        .lineSpacing(5)
                        .frame(alignment: .leading)
                }
                
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 6) {
                        if shopData.breakTimeHours.isEmpty {
                            HStack(alignment: .center, spacing: 0) {
                                Text("브레이크 타임이 없습니다.")
                                    .font(Font.pretendardBold14)
                                
                                Spacer()
                            }
                        } else {
                            ForEach(sortedWeekdays, id: \.self) { day in
                                if let hours = shopData.breakTimeHours[day] {
                                    HStack(spacing: 0) {
                                        Text("\(day)")
                                        
                                        VStack {
                                            Divider()
                                        }
                                        .padding(.horizontal, 5)
                                        
                                        if shopData.regularHoliday.contains(where: { holidayString in
                                            return holidayString == day
                                        }) {
                                            Text("정기 휴무")
                                        } else {
                                            ShopDetailHourTextView(startHour: hours.startHour, startMinute: hours.startMinute, endHour: hours.endHour, endMinute: hours.endMinute)
                                        }
                                    }
                                    .font(.pretendardBold14)
                                }
                            }
                        }
                    }
                    .padding(10)
                } label: {
                    Text("브레이크 타임")
                        .font(.pretendardMedium18)
                        .foregroundStyle(Color.privateColor)
                        .lineSpacing(5)
                        .frame(alignment: .leading)
                }
            }
        }
    }
    
    func isShopOpen(_ shop: Shop) -> String {
        let today = Date()
        if shop.regularHoliday.contains(AppDateFormatter.shared.dayString(from: today)) || shop.temporaryHoliday.contains(where: { date in
            return Calendar.current.isDate(date, inSameDayAs: today)
        }){
            return "휴무"
        }
        
        let calendar = Calendar.current
        let currentDay = AppDateFormatter.shared.dayString(from: today)
        
        var startDateComponents = DateComponents()
        startDateComponents.year = calendar.component(.year, from: today)
        startDateComponents.month = calendar.component(.month, from: today)
        startDateComponents.day = calendar.component(.day, from: today)
        startDateComponents.hour = shop.weeklyBusinessHours[currentDay]!.startHour
        startDateComponents.minute = shop.weeklyBusinessHours[currentDay]!.startMinute
        
        var endDateComponents = DateComponents()
        endDateComponents.year = calendar.component(.year, from: today)
        endDateComponents.month = calendar.component(.month, from: today)
        endDateComponents.day = calendar.component(.day, from: today)
        endDateComponents.hour = shop.weeklyBusinessHours[currentDay]!.endHour
        endDateComponents.minute = shop.weeklyBusinessHours[currentDay]!.endMinute
        
//        var startBreakTimeDateComponents = DateComponents()
//        startBreakTimeDateComponents.year = calendar.component(.year, from: today)
//        startBreakTimeDateComponents.month = calendar.component(.month, from: today)
//        startBreakTimeDateComponents.day = calendar.component(.day, from: today)
//        startBreakTimeDateComponents.hour = shop.breakTimeHours[currentDay]!.startHour
//        startBreakTimeDateComponents.minute = shop.breakTimeHours[currentDay]!.startMinute
//
//        var endBreakTimeDateComponents = DateComponents()
//        endBreakTimeDateComponents.year = calendar.component(.year, from: today)
//        endBreakTimeDateComponents.month = calendar.component(.month, from: today)
//        endBreakTimeDateComponents.day = calendar.component(.day, from: today)
//        endBreakTimeDateComponents.hour = shop.breakTimeHours[currentDay]!.endHour
//        endBreakTimeDateComponents.minute = shop.breakTimeHours[currentDay]!.endMinute
        
        if let startDate = calendar.date(from: startDateComponents),
           let endDate = calendar.date(from: endDateComponents) {
            if today >= startDate && today <= today {
//                if let breakTimeStart = calendar.date(from: startBreakTimeDateComponents),
//                   let breakTimeEnd = calendar.date(from: endBreakTimeDateComponents) {
//                    if today >= breakTimeStart && today <= breakTimeEnd {
//                        return "영업전"
//                    }
//                }
                return "영업중"
            }
        }
        
        return "영업전"
    }
}

struct ShopDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ShopDetailInfoView(shopData: ShopStore.shop)
    }
}

struct ShopDetailHourTextView: View {
    
    let startHour: Int
    let startMinute: Int
    let endHour: Int
    let endMinute: Int
    
    var body: some View {
        Text(String(format: "%02d:%02d - %02d:%02d", startHour, startMinute, endHour, endMinute))
    }
}
