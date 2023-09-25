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
    @Binding var reserv: Reservation
    @Binding var isSelectedTime: Bool
    
    static let today = Calendar.current.startOfDay(for: Date())
    var availableTimeSlots: [String] = []
    
    // (4칸이 꽉차도록 화면 너비에 비례하도록 하면 좋을듯)
    let colums = [GridItem(.adaptive(minimum: 60))] // 레이아웃 최소 사이즈
    
    
    // 오전, 오후 배열을 따로 분리할 필요가 있을 듯..!
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
            .tint(Color(.label))
            Divider()
                .padding(.bottom)
            
            if showingDate {
                DatePicker("Date", selection: $date, in: Self.today...,
                           displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding(.bottom)
                .onChange(of: date) { newValue in
                    reserv.date = newValue.timeIntervalSince1970
                    print(newValue)
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
                    .foregroundColor(Color("DarkGrayColor"))
                    .frame(width: 16, height: 16)
                Text("불가")
            }
            .tint(Color(.label))
            
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
            .tint(Color(.label))
            Divider()
            
            /*
             현시간~ 12로 나눴을 때.. 몫이 0이면 오전, 1이면 오후
             오늘이 아닌 다른 날일 때는 모든 가능시간 표현
             예약 불가한 타임(브레이크 타임 등은 음영처리 및 disable 처리)
             라이트모드 / 다크모드 고려
             
             */
            
            // 클릭했을 때 색상 변경
            if showingTime {
                VStack {
                    Text("오전")
                    
                    LazyVGrid(columns: colums, spacing: 20) {
                        ForEach(timeSlots, id: \.self) { timeSlot in
                            // 반복문 ForEach
                            VStack {
                                Button {
                                    // 시간 선택
                                    reserv.time = String(timeSlot)
                                    isSelectedTime = true
                                    print("\(timeSlot)")
                                } label: {
                                    Text("\(timeSlot)")  // 현재시간
                                        .frame(width: 60, height: 30)
                                }
                                .background(Color("SubGrayColor"))
                                .cornerRadius(8)
                            }
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
        DateTimePickerView(reservationStore: ReservationStore(), date: .constant(Date()), reserv: .constant(ReservationStore.reservation), isSelectedTime: .constant(false))
    }
}
