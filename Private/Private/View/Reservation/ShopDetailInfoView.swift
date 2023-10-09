//
//  ShopDetailInfoView.swift
//  Private
//
//  Created by H on 2023/09/26.
//

import SwiftUI

struct ShopwDetailInfoView: View {
    
    let dummyShop = ShopStore.shop
    let sortedWeekdays = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    Image(systemName: "text.justify.leading")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                }
                .frame(width: 25, height: 25)
                
                Text("소개")
                    .font(Font.pretendardMedium18)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(dummyShop.shopInfo)
                    .font(Font.pretendardRegular16)
            }
            .padding(10)
            
            Divider()
            
            HStack(spacing: 10) {
                ZStack {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                }
                .frame(width: 25, height: 25)
                
                Text("영업 시간")
                    .font(Font.pretendardMedium18)
                
                Spacer()
                
                ZStack {
                    Text("영업 전")
                        .font(Font.pretendardMedium18)
                        .padding(10)
                }
                .background(Color("SubGrayColor"))
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                ForEach(sortedWeekdays, id: \.self) { day in
                    if let hours = dummyShop.weeklyBusinessHours[day] {
                        HStack(spacing: 0) {
                            Text("\(day)")
                            
                            Spacer()
                            
                            if dummyShop.regularHoliday.contains(where: { holidayString in
                                return holidayString == day
                            }) {
                                Text("정기 휴무")
                            } else {
                                ShopDetailHourTextView(startHour: hours.startHour, startMinute: hours.startMinute, endHour: hours.endHour, endMinute: hours.endMinute)
                            }
                        }
                        .font(Font.pretendardRegular16)
                    }
                }
            }
            .padding(10)
            
            VStack(spacing: 10) {
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(dummyShop.temporaryHoliday, id: \.self) { day in
                            HStack(spacing: 0) {
                                Text(dateToFullString(date: day))
                                    .font(Font.pretendardRegular16)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(10)
                } label: {
                    Text("휴무일")
                        .font(Font.pretendardMedium18)
                        .lineSpacing(5)
                        .frame(alignment: .leading)
                }
                
                DisclosureGroup {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(sortedWeekdays, id: \.self) { day in
                            if let hours = dummyShop.breakTimeHours[day] {
                                HStack(spacing: 0) {
                                    Text("\(day)")
                                    
                                    Spacer()
                                    
                                    if dummyShop.regularHoliday.contains(where: { holidayString in
                                        return holidayString == day
                                    }) {
                                        Text("정기 휴무")
                                    } else {
                                        ShopDetailHourTextView(startHour: hours.startHour, startMinute: hours.startMinute, endHour: hours.endHour, endMinute: hours.endMinute)
                                    }
                                }
                                .font(Font.pretendardRegular16)
                            }
                        }
                    }
                    .padding(10)
                } label: {
                    Text("브레이크 타임")
                        .font(Font.pretendardMedium18)
                        .lineSpacing(5)
                        .frame(alignment: .leading)
                }
            }
        }
    }
    
    func dateToFullString(date: Date) -> String {
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct ShopDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ShopwDetailInfoView()
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
