//
//  ReservationView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct ReservationView: View {
    
    @ObservedObject var shopStore: ShopStore
    @ObservedObject var reservationStore: ReservationStore
    
    @State private var reserv = ReservationStore.reservation  // 더미데이터 사용
    @State private var showingDate: Bool = false
    @State private var showingNumbers: Bool = false
    @State private var date = Date()
    @State private var number = 1  // 인원
    
    @State private var isSelectedTime: Bool = false
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    private let step = 1
    private let range = 1...6  // 인원제한에 대한 정보가 없음
    
    
    /// Double 타입의 날짜를 String으로 변형.
    /// 만약, 예약 날짜가 오늘이면 오늘(요일) 형태로 바꿔줌
    var reservationDate: String {
        let reservationDate = Date(timeIntervalSince1970: reserv.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")  // 요일을 한국어로 얻기 위해 로케일 설정
        
        if Calendar.current.isDateInToday(reservationDate) {
            // 예약 날짜가 오늘일 경우
            dateFormatter.dateFormat = "오늘(E)" // 요일을 표시하는 형식으로 설정
        } else {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        }
        
        let dateString = dateFormatter.string(from: reservationDate)
        return dateString
    }
    
    
    //    /// 오늘이 무슨 요일인지 (수) 이런 식으로 나타내줌
    //    var dayOfWeek: String {
    //        let calendar = Calendar.current
    //        let components = calendar.dateComponents([.weekday], from: self.date)
    //        let weekday = components.weekday!
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.locale = Locale(identifier: "ko_KR") // 로케일을 한국으로 설정 (요일을 한국어로 얻기 위해)
    //        dateFormatter.dateFormat = "(E)" // 요일을 표시하는 형식으로 설정
    //
    //        let dayOfWeek = dateFormatter.string(from: self.date)
    //        return dayOfWeek
    //    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .opacity(0)
                
                // 메뉴마다 이렇게 있을 수 없음.. 식당에서는 예약 아이템을 어떻게 둬야할지
                ItemInfoView(shopStore: shopStore)
                    .padding(.bottom, 20)
                
                Text("예약 일시")
                    .font(Font.pretendardBold24)
                
                // 버튼의 범위를 HStack 전체로 할지 고민
                HStack {
                    Image(systemName: "calendar")
                    HStack {
                        Text(reservationDate)
                        //                        Text(isSelectedDate ? reservationDate : "오늘" + dayOfWeek)
                        Text(" / ")
                        Text(isSelectedTime ? reserv.time + "시": "시간")
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
                .padding(.bottom)
                
                if showingDate {
                    DateTimePickerView(reservationStore: reservationStore, date: $date, reserv: $reserv, isSelectedTime: $isSelectedTime)
                }
                
                
                // 예약 클릭 시 뷰가 새로 뜨게함
                
                Text("인원")
                    .font(Font.pretendardBold24)
                
                HStack {
                    Image(systemName: "person")
                    Text(isSelectedTime ? String(number) + "명" : "인원 선택")
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
                .background(Color("SubGrayColor"))
                .padding(.bottom, 20)
                
                // 뷰 따로 빼야함
                // 가게 예약 가능인원 정보를 받을지 말지 정해야함
                if showingNumbers {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("1~6명 까지 선택 가능합니다.")
                    }
                    
                    Divider()
                    
//                    Text("방문하시는 인원을 선택하세요")
                    // Stepper 안에 숫자를 넣으면 깔끔할 듯...
                    Stepper(value: $number, in: range, step: step) {
                        Text("\(number)")
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
                    
                    // BreakTime에 대한 Data 없음
                    Text("Break Time")
                    Text("월~금: 15:00 ~ 17:00")
                    Text("토~일: 15:00 ~ 17:00")
                    Text("당일 예약은 예약을 받지 않습니다.\n예약시간은 10분 경과시, 자동 취소됩니다.\n양해부탁드립니다.")
                }
                .padding()
                .background(Color("SubGrayColor"))
                .cornerRadius(12)
                .padding(.bottom, 30)
                
                Button {
                    // 예약하기 뷰로 넘어가기
                } label: {
                    Text("예약하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .tint(.black)
                .background(Color("AccentColor"))
                .cornerRadius(12)
                .disabled(!isSelectedTime)
                
            }// VStack
            
        }// ScrollView
        .padding()
        
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(shopStore: ShopStore(), reservationStore: ReservationStore(), root: .constant(true), selection: .constant(4))
    }
}
