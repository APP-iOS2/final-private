//
//  DateTimePickerView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/22.
//

import SwiftUI

struct DateTimePickerView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    
    @State private var showingDate: Bool = true
    @State private var showingTime: Bool = false
    @State private var amReservation: [Int] = []  // 오전 예약시간
    @State private var pmReservation: [Int] = []  // 오후 예약시간
    @State private var availableTimeSlots: [Int] = []

    @Binding var temporaryReservation: Reservation
    @Binding var isSelectedTime: Bool  // 시간대가 설정 되었는지
    
    @State private var today = Calendar.current.startOfDay(for: Date())
    
    let colums = [GridItem(.adaptive(minimum: 80))] // 레이아웃 최소 사이즈
    
    var body: some View {
        ScrollView {
            Button {
                showingDate.toggle()
            } label: {
                HStack {
                    Image(systemName: "calendar")
                    Text("날짜선택")
                    Spacer()
                    Image(systemName: showingDate ? "chevron.up.circle": "chevron.down.circle")
                }
                .font(Font.pretendardBold24)
            }
            .tint(.primary)
            Divider()
                .padding(.bottom)
            
            // 날짜 선택 화면 표시 여부
            if showingDate {
                DatePicker("Date", selection: $temporaryReservation.date, in: self.today...,
                           displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding(.bottom)
                .onChange(of: temporaryReservation.date) { newValue in
                    self.availableTimeSlots = reservationStore.getAvailableTimeSlots(open: 9, close: 21, date: temporaryReservation.date)
                    
                    separateReservationTime(timeSlots: availableTimeSlots)
                    print(temporaryReservation.date)
                }
            }
            
            HStack {
                Spacer()
                Rectangle()
                    .foregroundColor(Color("AccentColor"))
                    .frame(width: 16, height: 16)
                Text("선택")
                    .padding(.trailing, 6)
                Rectangle()
                    .foregroundColor(Color.darkGrayColor)
                    .frame(width: 16, height: 16)
                Text("불가")
            }
            .tint(.primary)
            
            Button {
                showingTime.toggle()
            } label: {
                HStack {
                    Image(systemName: "clock")
                    Text("시간선택")
                    Spacer()
                    Image(systemName: showingTime ? "chevron.up.circle": "chevron.down.circle")
                }
                .font(Font.pretendardBold24)
            }
            .tint(.primary)
            Divider()
            
            // 시간 선택 화면 표시 여부
            if showingTime {
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    
                    // 오전
                    if amReservation.count > 0 {
                        Text("오전")
                        
                        LazyVGrid(columns: colums, spacing: 20) {
                            ForEach(amReservation, id: \.self) { timeSlot in
                                VStack {
                                    Button {
                                        self.temporaryReservation.time = timeSlot
                                        isSelectedTime = true
                                        print("\(timeSlot)")
                                    } label: {
                                        Text("\(timeSlot):00")  // 현재시간
                                            .frame(minWidth: 60, maxWidth: .infinity)
                                            .frame(height: 35)
                                    }
                                    .background(timeSlot == self.temporaryReservation.time ? Color("AccentColor") : Color.subGrayColor)
                                    .tint(timeSlot == self.temporaryReservation.time ? .primary : Color(.systemGray))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // 오후
                    if pmReservation.count > 0 {
                        Text("오후")
                        
                        LazyVGrid(columns: colums, spacing: 20) {
                            ForEach(pmReservation, id: \.self) { timeSlot in
                                // 반복문 ForEach
                                VStack {
                                    Button {
                                        // 시간 선택
                                        // 버튼이 눌리면 색상 바꿔주기
                                        self.temporaryReservation.time = timeSlot
                                        isSelectedTime = true
                                        print("\(timeSlot)")
                                    } label: {
                                        Text("\(timeSlot):00")  // 현재시간
                                            .frame(minWidth: 60, maxWidth: .infinity)
                                            .frame(height: 35)
                                    }
                                    .background(timeSlot == self.temporaryReservation.time ? Color("AccentColor") : Color.subGrayColor)
                                    .tint(timeSlot == self.temporaryReservation.time ? Color(.label) : Color(.systemGray))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // 이용 가능 시간대가 없을 때
                    if availableTimeSlots.isEmpty {
                        VStack {
                            Text("예약 가능한 시간이 없습니다.")
                            Text("다른 날짜를 선택해주세요.")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.primary)
                        .background(Color.subGrayColor)
                        .cornerRadius(8)
                    }
                    
                }
            }
            
        }
        .padding()
        .onAppear {
            self.today = Calendar.current.startOfDay(for: Date())
            self.availableTimeSlots = reservationStore.getAvailableTimeSlots(open: 9, close: 21, date: temporaryReservation.date)
            
            // 날짜의 기본값이 오늘일 때를 위함
            separateReservationTime(timeSlots: availableTimeSlots)
        }
        .refreshable {
            self.today = Calendar.current.startOfDay(for: Date())
            self.availableTimeSlots = reservationStore.getAvailableTimeSlots(open: 9, close: 21, date: temporaryReservation.date)
        }
        
    }
    
    // 나중에 수정해야지..
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
        DateTimePickerView(temporaryReservation: .constant(ReservationStore.tempReservation), isSelectedTime: .constant(true))
            .environmentObject(ReservationStore())
    }
}
