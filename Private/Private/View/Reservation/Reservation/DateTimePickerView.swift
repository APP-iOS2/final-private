//
//  DateTimePickerView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/22.
//

import SwiftUI

struct DateTimePickerView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var holidayManager: HolidayManager
    @EnvironmentObject var calendarData: CalendarData
    
    @State private var showingDate: Bool = true
    @State private var showingTime: Bool = false
    @State private var amReservation: [Int] = []  // 오전 예약시간
    @State private var pmReservation: [Int] = []  // 오후 예약시간
    @State private var availableTimeSlots: [Int] = []
    @State private var today = Calendar.current.startOfDay(for: Date())
    @State private var disabledPreviousButton: Bool = false
    @State private var disabledNextButton: Bool = false
    
    @Binding var temporaryReservation: Reservation
    @Binding var isSelectedTime: Bool  // 시간대가 설정 되었는지
    
    let shopData: Shop
    private let colums = [GridItem(.adaptive(minimum: 80))] // 레이아웃 최소 사이즈
    
    var body: some View {
        ScrollView {
            HStack {
                Text(calendarData.strMonthTitle) // FSCalendar 위에 달력 타이틀
                    .font(.pretendardMedium18)
                Spacer()
                
                // prevButton
                Button {
                    self.calendarData.currentPage = Calendar.current.date(byAdding: .month, value: -1, to: self.calendarData.currentPage)!
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 35, height: 35, alignment: .leading)
                        .foregroundStyle(calendarData.disablePrevButton ? Color.secondary : Color.privateColor)
                }
                .disabled(calendarData.disablePrevButton)
                
                // nextButton
                Button {
                    self.calendarData.currentPage = Calendar.current.date(byAdding: .month, value: 1, to: self.calendarData.currentPage)!
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 35, height: 35, alignment: .trailing)
                        .foregroundStyle(calendarData.disableNextButton ? Color.secondary : Color.privateColor)
                }
                .disabled(calendarData.disableNextButton)
                
            }
            .padding(.horizontal)
            
            FSCalendarView(regularHoliday: holidayManager.regularHolidayToInt(shopData: shopData), temporaryHoliday: shopData.temporaryHoliday, publicHolidays: holidayManager.publicHolidays)
                .frame(height: 300)
                .padding(.bottom)
                .onChange(of: calendarData.selectedDate) { newValue in
                    self.availableTimeSlots = reservationStore.getAvailableTimeSlots(open: 9, close: 21, date: newValue)
                    
                    separateReservationTime(timeSlots: availableTimeSlots)
                }
            
            PrivateDivder()
            
            VStack(alignment: .leading) {
                Divider()
                    .opacity(0)
                
                if amReservation.count > 0 {
                    Text("오전")
                    ReservationTime(isSelectedTime: $isSelectedTime, timeOfDay: $amReservation, reservationData: $temporaryReservation)
                }
                if pmReservation.count > 0 {
                    Text("오후")
                    ReservationTime(isSelectedTime: $isSelectedTime, timeOfDay: $pmReservation, reservationData: $temporaryReservation)
                }
                if availableTimeSlots.isEmpty {
                    VStack {
                        Text("예약 가능한 시간이 없습니다.")
                        Text("다른 날짜를 선택해주세요.")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.pretendardMedium18)
                    .foregroundColor(.white)
                    .background(Color.subGrayColor)
                    .cornerRadius(8)
                }
                
            }
        }
        .padding(.horizontal)
        .onAppear {
            self.today = Calendar.current.startOfDay(for: Date())
            self.availableTimeSlots = reservationStore.getAvailableTimeSlots(open: 9, close: 21, date: temporaryReservation.date)
            
            // 날짜의 기본값이 오늘일 때를 위함
            separateReservationTime(timeSlots: availableTimeSlots)
        }
    }
    
    /// 예약 가능한 시간대를 오전, 오후로 나눠서 두 개의 배열로 리턴
    /// - Parameter timeSlots: 예약 가능한 시간대
    func separateReservationTime(timeSlots: [Int]) {
        var morningTimeSlots: [Int] = []
        var afternoonTimeSlots: [Int] = []
        
        for timeSlot in timeSlots {
            if timeSlot < 12 {
                morningTimeSlots.append(timeSlot)
            } else {
                afternoonTimeSlots.append(timeSlot)
            }
        }
        amReservation = morningTimeSlots
        pmReservation = afternoonTimeSlots
    }
    
}

struct DateTimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimePickerView(temporaryReservation: .constant(ReservationStore.tempReservation), isSelectedTime: .constant(true), shopData: ShopStore.shop)
            .environmentObject(ReservationStore())
            .environmentObject(HolidayManager())
            .environmentObject(CalendarData())
    }
}

/// 예약 시간 선택 버튼 뷰
struct ReservationTime: View {
    @EnvironmentObject var reservationStore: ReservationStore
    private let colums = [GridItem(.adaptive(minimum: 80))] // 레이아웃 최소 사이즈
    
    @Binding var isSelectedTime: Bool
    @Binding var timeOfDay: [Int]
    @Binding var reservationData: Reservation
    
    var body: some View {
        LazyVGrid(columns: colums, spacing: 20) {
            ForEach(timeOfDay, id: \.self) { timeSlot in
                // 반복문 ForEach
                VStack {
                    Button {
                        self.reservationData.time = timeSlot
                        isSelectedTime = true
                    } label: {
                        Text("\(timeSlot):00")  // 현재시간
                            .frame(minWidth: 60, maxWidth: .infinity)
                            .frame(height: 35)
                    }
                    .background(timeSlot == self.reservationData.time ? Color.privateColor : Color.subGrayColor)
                    .tint(timeSlot == self.reservationData.time ? .black : Color(.systemGray))
                    .cornerRadius(8)
                }
            }
        }
    }
}
