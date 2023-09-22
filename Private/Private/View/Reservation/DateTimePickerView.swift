//
//  DateTimePickerView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/22.
//

import SwiftUI

extension String {
    func stringFromDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: now)
    }
}

// 오늘의 목표 버튼까지 만들기
struct DateTimePickerView: View {
    @ObservedObject var reservationStore: ReservationStore
    
    @State private var showingDate: Bool = true
    @State private var showingTime: Bool = false
    
    @Binding var date: Date
    
    static let today = Calendar.current.startOfDay(for: Date())
    var availableTimeSlots: [String] = []
    
    var timeSlots: [Int] {
        let nowInt = Int("HH".stringFromDate())
        let endTime: Int = 21
        if let nowInt {
            let times = Array(nowInt + 1...endTime)
            return times
        }
        return [0]
    }
    
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
            .tint(.white)
            Divider()
            
            if showingDate {
                DatePicker("Date", selection: $date, in: Self.today...,
                           displayedComponents: [.date])
                .datePickerStyle(.graphical)
            }
                        HStack {
                Spacer()
                Rectangle()
                    .foregroundColor(Color("AccentColor"))
                    .frame(width: 16, height: 16)
                Text("선택")
                    .padding(.trailing, 6)
                Rectangle()
                    .foregroundColor(Color("DarkGrayColor"))
                    .frame(width: 16, height: 16)
                Text("불가")
            }
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
            .tint(.white)
            Divider()
            
            if showingTime {
                VStack {
                    Text("오전")
                    
                    HStack {
                        
                        ForEach(timeSlots, id: \.self) { timeSlot in
                            // 반복문 ForEach
                            Button {
                                // 시간 선택
                            } label: {
                                // 한시간 단위로 현 시간 이후로..!!
                                Text("\(timeSlot)")  // 현재시간
                                
                            }
                            .background(Color("SubGrayColor"))
                        }
                       

                    }
                    
                }
            }
            
            
        }
        .padding()
    }
}

struct DateTimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimePickerView(reservationStore: ReservationStore(), date: .constant(Date()))
    }
}
