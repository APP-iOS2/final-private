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
    
    @State private var showingDate: Bool = true    // 예약 일시 선택
    @State private var isSelectedTime: Bool = false
    @State private var temporaryReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    
    private let step = 1  // 인원선택 stepper의 step
    private let range = 1...6  // stepper 인원제한
    
    let shopData: Shop
    
    var myReservation: Reservation {
        return reservationStore.myReservation
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    
                    Text("예약 일시")
                        .font(.pretendardBold20)
                        .foregroundStyle(Color.primary)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(isSelectedTime ? "\(reservationStore.getReservationDate(reservationDate: calendarData.selectedDate)) / \(self.reservedTime) \(self.reservedHour)시" : "날짜와 시간을 선택해주세요" )
                            .font(.pretendardMedium18)
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showingDate.toggle()
                            }
                        } label: {
                            Image(systemName: showingDate ? "chevron.up.circle": "chevron.down.circle")
                                .foregroundStyle(Color.privateColor)
                                .imageScale(.large)
                            
                        }
                    }
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
                    PrivateDivder()
                    Text("인원")
                        .font(.pretendardBold20)
                        .foregroundStyle(Color.primary)
                    
                    HStack {
                        Stepper(value: $temporaryReservation.numberOfPeople, in: range, step: step) {
                            Label("\(temporaryReservation.numberOfPeople)명", systemImage: "person")
                        }
                    }
                    .font(.pretendardMedium18)
                    .foregroundStyle(.primary)
                    .padding(.bottom, 8)
                    
                    HStack {
                        Image(systemName: "info.circle")
                        Text("1~6명 까지 선택 가능합니다.")
                            .font(.pretendardRegular16)
                    }
                    .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("알립니다")
                            Spacer()
                        }
                        .font(.pretendardBold18)
                        .foregroundColor(Color.privateColor)
                        .padding(.bottom, 6)
                        
                        Group {
                            Text("노쇼 방지를 위해 인원당 10,000원의 보증금을 받습니다.")
                                .padding(.bottom, 8)
                            Text("당일 예약은 예약시간 1시간 전까지 가능합니다.")
                        }
                        .font(.pretendardRegular16)
                        .foregroundStyle(Color.primary)
                    }
                    .padding()
                    .background(Color.subGrayColor)
                    .cornerRadius(12)
                }// VStack
                .padding(.bottom)
                
                Spacer() // 가장 밑으로 가도록 해야 함
                
                NavigationLink {
                    ReservationDetailView(reservationData: $temporaryReservation, shopData: shopData)
                } label: {
                    Text("다음단계")
                        .font(.pretendardBold18)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .simultaneousGesture(TapGesture().onEnded{
                    temporaryReservation.date = calendarData.selectedDate
                    temporaryReservation.totalPrice = (temporaryReservation.numberOfPeople * 10000)
                })
                .foregroundStyle(isSelectedTime ? .black : Color.secondary)
                .background(Color.privateColor)
                .cornerRadius(12)
                .disabled(!isSelectedTime)
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
            .padding()
            .navigationTitle(shopData.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(shopData: ShopStore.shop)
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
            .environmentObject(HolidayManager())
            .environmentObject(CalendarData())
    }
}
