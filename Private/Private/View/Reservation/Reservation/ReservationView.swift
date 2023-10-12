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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(shopData.name)
                    .font(.pretendardBold24)
                    .padding(.bottom)
                
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
                    .font(Font.pretendardMedium24)
                    .padding()
                    .background(Color("SubGrayColor"))
                    .padding(.bottom)
                    
                    if showingDate {
                        DateTimePickerView(temporaryReservation: $temporaryReservation, isSelectedTime: $isSelectedTime)
                            .onChange(of: temporaryReservation.time) { newValue in
                                self.reservedTime = reservationStore.conversionReservedTime(time: newValue).0
                                self.reservedHour = reservationStore.conversionReservedTime(time: newValue).1
                            }
                    }
                    
                    Text("인원")
                        .font(Font.pretendardBold24)
                    
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
                    .padding(.bottom, 20)
                    
                    // 뷰 따로 빼야함
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
                        
                        // BreakTime에 대한 Data 없음
                        Text("Break Time")
                        Text("월~금: 15:00 ~ 17:00")
                        Text("토~일: 15:00 ~ 17:00")
                        Text("당일 예약은 예약을 받지 않습니다.\n예약시간은 10분 경과시, 자동 취소됩니다.\n양해부탁드립니다.")
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
