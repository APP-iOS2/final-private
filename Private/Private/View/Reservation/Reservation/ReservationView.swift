//
//  ReservationView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct ReservationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var holidayManager: HolidayManager
    @EnvironmentObject var calendarData: CalendarData
    
    @State private var showingDate: Bool = false    // 예약 일시 선택
    @State private var showingNumbers: Bool = false // 예약 인원 선택
    @State private var isSelectedTime: Bool = false
    @State private var isShwoingDetailView: Bool = false
    @State private var temporaryReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    
    @Binding var isReservationPresented: Bool
    
    private let step = 1  // 인원선택 stepper의 step
    private let range = 1...6  // stepper 인원제한
    
    let shopData: Shop
    
    var myReservation: Reservation {
        return reservationStore.myReservation
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    Text(shopData.name)
                        .font(.pretendardBold24)
                        .foregroundStyle(.white)
                        .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Divider()
                            .opacity(0)
                        
                        Text("예약 일시")
                            .font(.pretendardBold18)
                            .foregroundStyle(.white)
                        
                        HStack {
                            Image(systemName: "calendar")
                            HStack {
                                // 이 때 호출하면 언제 메소드는 언제 호출되는거야?
                                Text(reservationStore.getReservationDate(reservationDate: calendarData.selectedDate))
                                Text(" / ")
                                Text(isSelectedTime ? self.reservedTime + " \(self.reservedHour)시" : "시간")
                            }
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    showingDate.toggle()
                                }
                            } label: {
                                Image(systemName: showingDate ? "chevron.up.circle": "chevron.down.circle")
                                    .foregroundStyle(Color.privateColor)
                            }
                        }
                        .font(.pretendardMedium18)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.subGrayColor)
                        .cornerRadius(12)
                        .padding(.bottom)
                        
                        if showingDate {
                            DateTimePickerView(temporaryReservation: $temporaryReservation, isSelectedTime: $isSelectedTime, shopData: shopData)
                                .onChange(of: temporaryReservation.time) { newValue in
                                    self.reservedTime = reservationStore.conversionReservedTime(time: newValue).0
                                    self.reservedHour = reservationStore.conversionReservedTime(time: newValue).1
                                }
                        }
                        
                        Text("인원")
                            .font(.pretendardBold18)
                        
                        HStack {
                            Image(systemName: "person")
                            Text(isSelectedTime ? String(temporaryReservation.numberOfPeople) + "명" : "인원 선택")
                            Spacer()
                            Button {
                                withAnimation {
                                    showingNumbers.toggle()
                                }
                            } label: {
                                Image(systemName: showingNumbers ? "chevron.up.circle": "chevron.down.circle")
                                    .foregroundStyle(isSelectedTime ? Color.privateColor : Color.secondary)
                            }
                            .disabled(!isSelectedTime)
                        }
                        .font(.pretendardMedium18)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.subGrayColor)
                        .cornerRadius(12)
                        .padding(.bottom, 20)
                        
                        if showingNumbers {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("1~6명 까지 선택 가능합니다.")
                                    .font(.pretendardRegular16)
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
                            .font(.pretendardBold18)
                            .foregroundColor(Color.privateColor)
                            .padding(.bottom, 6)
                            
                            Group {
                                Text("노쇼 방지를 위해 인원당 10,000원의 보증금을 받습니다.")
                                    .padding(.bottom)
                                Text("당일 예약은 예약시간 1시간 전까지 가능합니다.")
                            }
                            .font(.pretendardRegular16)
                            .foregroundStyle(Color.primary)
                        }
                        .padding()
                        .background(Color.subGrayColor)
                        .cornerRadius(12)
                    }// VStack
                }// ScrollView
                
                ReservationButton(text: "다음단계") {
                    temporaryReservation.date = calendarData.selectedDate
                    temporaryReservation.totalPrice = (temporaryReservation.numberOfPeople * 10000)
                    isShwoingDetailView.toggle()
                }
                .font(.pretendardBold20)
                .foregroundStyle(isSelectedTime ? .black : Color.secondary)
                .disabled(!isSelectedTime)
                
                .navigationDestination(isPresented: $isShwoingDetailView) {
                    ReservationDetailView(isShwoingDetailView: $isShwoingDetailView, isReservationPresented: $isReservationPresented, reservationData: $temporaryReservation, shopData: shopData)
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .backButtonArrow()
                .onAppear {
                    self.temporaryReservation.shopId = self.shopData.id
                    calendarData.selectedDate = calendarData.getSelectedDate(shopData: shopData)
                    calendarData.currentPage = calendarData.getSelectedDate(shopData: shopData)
                    calendarData.titleOfMonth = calendarData.getSelectedDate(shopData: shopData)
                    temporaryReservation.date = calendarData.getSelectedDate(shopData: shopData)
                }
            }
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(isReservationPresented: .constant(true), shopData: ShopStore.shop)
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
            .environmentObject(HolidayManager())
            .environmentObject(CalendarData())
    }
}
