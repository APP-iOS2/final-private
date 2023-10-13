//
//  ReservationView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct ReservationView: View {
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    @ObservedObject private var calendarData = CalendarData()

    @State private var showingDate: Bool = false    // 예약 일시 선택
    @State private var showingNumbers: Bool = false // 예약 인원 선택
    @State private var isSelectedTime: Bool = false
    @State private var isShwoingConfirmView: Bool = false
    @State private var temporaryReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    
    @Binding var isReservationPresented: Bool
    
    private let step = 1  // 인원선택 stepper의 step
    private let range = 1...6  // stepper 인원제한
    
    let shopData: Shop
    let sortedWeekdays = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]

    @State private var disabledPreviousButton: Bool = false
    @State private var disabledNextButton: Bool = false
    
    var strMonthTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: calendarData.titleOfMonth)
    }
    
    var disablePrevButton: Bool {
        let currentDate = Date()
        let calendar = Calendar.current  // 캘린더 인스턴스 생성
        
        // 현재 날짜에서 연도/월 추출
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        
        // 현재 페이지에서 연도/월 추출
        let pageYear = calendar.component(.year, from: calendarData.currentPage)
        let pageMonth = calendar.component(.month, from: calendarData.currentPage)
        
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
        let pageYear = calendar.component(.year, from: calendarData.currentPage)
        let pageMonth = calendar.component(.month, from: calendarData.currentPage)
        
        if year == pageYear && month == pageMonth {
            return true
        } else {
            return false
        }
    }
    
    var regualrHoloday: [Int] {
        var regularHoliday: [Int] = []
        
        for holiday in shopData.regularHoliday {
            switch holiday {
            case "일요일":
                regularHoliday.append(1)
            case "월요일":
                regularHoliday.append(2)
            case "화요일":
                regularHoliday.append(3)
            case "수요일":
                regularHoliday.append(4)
            case "목요일":
                regularHoliday.append(5)
            case "금요일":
                regularHoliday.append(6)
            case "토요일":
                regularHoliday.append(7)
            default:
                break
            }
        }
        return regularHoliday
    }

    func getDisabled() -> (Bool, Bool) {
        let calendar = Calendar.current
        var thisMonthComponents = calendar.dateComponents([.year, .month], from: Date())
        thisMonthComponents.hour = 0
        thisMonthComponents.minute = 0
        thisMonthComponents.second = 0
        
        var currentPageComponents = calendar.dateComponents([.year, .month], from: calendarData.currentPage)
        currentPageComponents.hour = 0
        currentPageComponents.minute = 0
        currentPageComponents.second = 0
        
        let today = calendar.date(from: thisMonthComponents) ?? Date()
        let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: today) ?? today
        let currentPageDay = calendar.date(from: currentPageComponents) ?? Date()
        
        var previosButton: Bool
        var nextButton: Bool
        
        if currentPageDay == today {
            previosButton = true
        } else { previosButton = false }
        
        if currentPageDay == oneYearFromNow {
            nextButton = true
        } else {
            nextButton = false
        }
        
        return (previosButton, nextButton)
    }  // 코드 수정 필요 - 기능은 잘 됨 ->
    // 스왑할 때는 안됨 -> 해당 값이 바뀔 때마다 호출해주면 될 듯
    
    // 문제 스왑하고 버튼으로 하면 11월로 넘어감 -> 스왑했을 때
    // updateUIView로 인해 UIView가 바뀔 때는 didChange가 동작하지만, didChange로 동작할 때는 updateUIView가 동작하지않음
    // 둘을 이어줘야 함
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(shopData.name)
                    .font(.pretendardBold24)
                    .padding(.bottom)
                
                // FSCalendarView 넣기
                HStack {
                    // previousButton
                    
                    Text(strMonthTitle)
                    Spacer()
                    Button {
                        self.calendarData.currentPage = Calendar.current.date(byAdding: .month, value: -1, to: self.calendarData.currentPage)!
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 35, height: 35, alignment: .leading)
                    }
                    .disabled(disablePrevButton)
                    
                    // nextButton
                    Button {
                        self.calendarData.currentPage = Calendar.current.date(byAdding: .month, value: 1, to: self.calendarData.currentPage)!
                    } label: {
                        Image(systemName: "chevron.right")
                            .frame(width: 35, height: 35, alignment: .trailing)
                    }
                    .disabled(disableNextButton)
                    
                }
                .padding(.horizontal)
                
                FSCalendarView(currentPage: $calendarData.currentPage, selectedDate: $temporaryReservation.date, calendarTitle: $calendarData.titleOfMonth, regularHoliday: regualrHoloday, temporaryHoliday: shopData.temporaryHoliday)
                    .frame(height: 300)
                
                
                
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    
                    Text("예약 일시")
                        .font(Font.pretendardBold18)
                    
                    HStack {
                        Image(systemName: "calendar")
                        HStack {
                            Text(reservationStore.getReservationDate(reservationDate: temporaryReservation.date))
                            Text(" / ")
                            Text(isSelectedTime ? self.reservedTime + " \(self.reservedHour)시" : "시간")
                        }
                        Spacer()
                        
                        Button {
                            showingDate.toggle()
                        } label: {
                            Image(systemName: showingDate ? "chevron.up.circle": "chevron.down.circle")
                        }
                    }
                    .font(Font.pretendardMedium18)
                    .padding()
                    .background(Color("SubGrayColor"))
                    .cornerRadius(12)
                    .padding(.bottom)
                    
                    if showingDate {
                        DateTimePickerView(temporaryReservation: $temporaryReservation, isSelectedTime: $isSelectedTime)
                            .onChange(of: temporaryReservation.time) { newValue in
                                self.reservedTime = reservationStore.conversionReservedTime(time: newValue).0
                                self.reservedHour = reservationStore.conversionReservedTime(time: newValue).1
                            }
                    }
                    
                    Text("인원")
                        .font(Font.pretendardBold18)
                    
                    HStack {
                        Image(systemName: "person")
                        Text(isSelectedTime ? String(temporaryReservation.numberOfPeople) + "명" : "인원 선택")
                        Spacer()
                        Button {
                            showingNumbers.toggle()
                        } label: {
                            Image(systemName: showingNumbers ? "chevron.up.circle": "chevron.down.circle")
                        }
                        .disabled(!isSelectedTime)
                    }
                    .font(Font.pretendardMedium18)
                    .padding()
                    .background(Color.subGrayColor)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                    
                    // 가게 예약 가능인원 정보를 받을지 말지 정해야함
                    if showingNumbers {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("1~6명 까지 선택 가능합니다.")
                                .font(Font.pretendardRegular16)
                        }
                        
                        Divider()
                        
                        Stepper(value: $temporaryReservation.numberOfPeople, in: range, step: step) {
                            Text("\(temporaryReservation.numberOfPeople)")
                        }
                        .padding(10)
                    }
                    
                    VStack(alignment: .leading) {
                        Divider()
                            .opacity(0)
                        HStack {
                            Image(systemName: "info.circle")
                            Text("알립니다")
                        }
                        .font(Font.pretendardBold18)
                        .foregroundColor(Color("AccentColor"))
                        .padding(.bottom, 6)
                        
                        Text("Break Time")
                            .font(Font.pretendardMedium18)
                        
                        VStack(alignment: .leading) {
                            ForEach(sortedWeekdays, id: \.self) { day in
                                if let hours = shopData.breakTimeHours[day] {
                                    HStack {
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
                                    .padding(.bottom, 1)
                                }
                            }
                            if shopData.breakTimeHours.isEmpty {
                                Text("브레이크 타임이 없습니다.")
                            }
                        }
                        .padding(10)
                        
                        Text("당일 예약은 예약시간 1시간 전까지 가능합니다.")
                            .padding(.bottom, 1)
                        Text("예약시간은 10분 경과시, 자동 취소됩니다.\n양해부탁드립니다.")
                    }
                    .padding()
                    .background(Color.subGrayColor)
                    .cornerRadius(12)
                    .padding(.bottom, 30)
                    
                    HStack {
                        ReservationButton(text: "다음단계") {
                            isShwoingConfirmView.toggle()
                        }
                        .foregroundStyle(isSelectedTime ? .primary : Color.gray)
                        .disabled(!isSelectedTime)
                    }
                    .navigationDestination(isPresented: $isShwoingConfirmView) {
                        ReservationDetailView(isShwoingConfirmView: $isShwoingConfirmView, isReservationPresented: $isReservationPresented, reservationData: $temporaryReservation, shopData: shopData)
                    }
                }// VStack
            }// ScrollView
            .padding()
            .onAppear {
                self.temporaryReservation.shopId = self.shopData.id
                print("tempHoliday = \(shopData.temporaryHoliday) ~~~~~~")
            }
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(isReservationPresented: .constant(true), shopData: ShopStore.shop)
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
    }
}
