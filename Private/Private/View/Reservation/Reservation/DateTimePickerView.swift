//
//  DateTimePickerView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/22.
//

import SwiftUI

// 예약일이 날짜, 시간까지 통채로 있어서 한 번에 동기화되도록 가능할까..

// 오늘의 목표 버튼까지 만들기
struct DateTimePickerView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    
    @State private var showingDate: Bool = true
    @State private var showingTime: Bool = false
    @State private var amReservation: [Int] = []  // 오전 예약시간
    @State private var pmReservation: [Int] = []  // 오후 예약시간
    
    @Binding var temporaryReservation: Reservation
    @Binding var isSelectedTime: Bool  // 시간대가 설정 되었는지
    
    static let today = Calendar.current.startOfDay(for: Date())
    var availableTimeSlots: [String] = []
    
    let colums = [GridItem(.adaptive(minimum: 80))] // 레이아웃 최소 사이즈
    
    /// 현재 시간 기준으로 +1 시간하여 예약 가능한 시간대를 배열로 변환
    var timeSlots: [Int] {
        // 오늘이 아니라면 -> 전체 시간을 일단 띄워야 함
        let reservationDate = temporaryReservation.date
        if Calendar.current.isDateInToday(reservationDate) {
            // 선택한 날짜가 오늘일 때
            // 현 시간이 오전 9시보다 ~~일 때 고려
            let nowInt = Int("HH".stringFromDate())
            let startTime: Int = 9
            let endTime: Int = 21
            
            if let nowInt {
                // 현재 시간이 마감시간보다 늦으면 indexError가 나는 것을 방지
                // 현재시간이 마감시간과 같거나, 같을 때
                guard nowInt < endTime else {
                    return []
                }
                
                // 현재 시간이 9시 전이거나 같을 때
                guard nowInt >= startTime else {
                    let times = Array(startTime...endTime - 1)
                    return times
                }
                
                let times = Array(nowInt + 1...endTime - 1)
                return times
            }
        } else {
            // 선택한 날짜가 미래 일 때
            let openTime: Int = 9
            let endTime: Int = 21
            let times = Array(openTime...endTime - 1)
            return times
        }
        return [0]
    }
    
    // 달력 누르면 해당일에 해당하는 시간대가 나와야 함!!!
    // selectedDate가 되면 시간선택에 있는 배열도 새로 만들어져야 함..!
    
    var body: some View {
        ScrollView {
            
            // 날짜 선택 버튼
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
                DatePicker("Date", selection: $temporaryReservation.date, in: Self.today...,
                           displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding(.bottom)
                .onChange(of: temporaryReservation.date) { newValue in
                    separateReservationTime(timeSlots: timeSlots)
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
            
            /*
             현시간~ 12로 나눴을 때.. 몫이 0이면 오전, 1이면 오후
             오늘이 아닌 다른 날일 때는 모든 가능시간 표현
             예약 불가한 타임(브레이크 타임 등은 음영처리 및 disable 처리)
             라이트모드 / 다크모드 고려
             
             */
            
            // 시간 선택 화면 표시 여부
            if showingTime {
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    
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
                    
                    if timeSlots.count == 0 {
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
        .onAppear {
            // 날짜의 기본값이 오늘일 때를 위함
            separateReservationTime(timeSlots: timeSlots)
        }
        .padding()
    }
    
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
        DateTimePickerView(temporaryReservation: .constant(Reservation(shopId: "shopId", reservedUserId: "userId", date: Date(), time: 16, numberOfPeople: 5, totalPrice: 30000)), isSelectedTime: .constant(true))
            .environmentObject(ReservationStore())
    }
}
