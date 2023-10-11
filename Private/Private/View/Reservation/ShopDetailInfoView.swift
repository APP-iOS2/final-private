//
//  ShopDetailInfoView.swift
//  Private
//
//  Created by H on 2023/09/26.
//

import SwiftUI

struct ShopDetailInfoView: View {
    
    let shopData: Shop
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
                Text(shopData.shopInfo)
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
                    Text("영업 전")  // 오픈 시간 전이면 영업 전, 마감 시간 이후 ~ 영업 종료
                        .font(Font.pretendardMedium18)
                        .padding(10)
                }
                .background(Color("SubGrayColor"))
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                ForEach(sortedWeekdays, id: \.self) { day in
                    if let hours = shopData.weeklyBusinessHours[day] {
                        HStack(spacing: 0) {
                            Text("\(day)")
                            
                            Spacer()
                            
                            if shopData.regularHoliday.contains(where: { holidayString in
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
                        ForEach(shopData.temporaryHoliday, id: \.self) { day in
                            HStack(spacing: 0) {
                                Text(AppDateFormatter.shared.fullDateString(from: day))
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
                            if let hours = shopData.breakTimeHours[day] {
                                HStack(spacing: 0) {
                                    Text("\(day)")
                                    
                                    Spacer()
                                    
                                    if shopData.regularHoliday.contains(where: { holidayString in
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
