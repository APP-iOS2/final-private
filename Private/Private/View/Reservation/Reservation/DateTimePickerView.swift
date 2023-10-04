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
    @State private var availableTimeSlots: [Int] = []

    @Binding var temporaryReservation: Reservation
    @Binding var isSelectedTime: Bool  // 시간대가 설정 되었는지
    
    @State private var today = Calendar.current.startOfDay(for: Date())
    
    let colums = [GridItem(.adaptive(minimum: 80))] // 레이아웃 최소 사이즈
    
    /// 현재 시간 기준으로 +1 시간하여 예약 가능한 시간대를 배열로 변환
//    var timeSlots: [Int] {
//        // 오늘이 아니라면 -> 전체 시간을 일단 띄워야 함
//        let reservationDate = temporaryReservation.date
//        
//        let openTime: Int = 9
//        let closeTime: Int = 21
//        
//        if Calendar.current.isDateInToday(reservationDate) {
//            let nowInt = Int("HH".stringFromDate())
//
//            
//            if let nowInt {
//                // 현재 시간이 마감시간보다 같거나 늦으면 빈 배열 반환
//                guard nowInt <= closeTime else {
//                    return []
//                }
//                
//                // 현재 시간이 오픈시간 전이거나 같을 때
//                guard nowInt >= openTime else {
//                    let times = Array(openTime...closeTime - 1)
//                    return times
//                }
//                
//                // 오픈시간 ~ 마감시간 전일 때
//                let times = Array(nowInt + 1...closeTime - 1)
//                return times
//            }
//        } else {
//            // 선택한 날짜가 미래 일 때
//            let times = Array(openTime...closeTime - 1)
//            return times
//        }
//        return [0]
//    }
    
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
                DatePicker("Date", selection: $temporaryReservation.date, in: self.today...,
                           displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding(.bottom)
                .onChange(of: temporaryReservation.date) { newValue in
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
        DateTimePickerView(temporaryReservation: .constant(Reservation(shopId: "shopId", reservedUserId: "userId", date: Date(), time: 16, numberOfPeople: 5, totalPrice: 30000)), isSelectedTime: .constant(true))
            .environmentObject(ReservationStore())
    }
}
