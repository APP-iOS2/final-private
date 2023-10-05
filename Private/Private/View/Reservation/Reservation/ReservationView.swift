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
    
    //    @State private var reservationDateString: String = ""
    @State private var showingDate: Bool = false    // 예약 일시 선택
    @State private var showingNumbers: Bool = false // 예약 인원 선택
    @State private var isSelectedTime: Bool = false
    @State private var isShwoingConfirmView: Bool = false
    @State private var isShowingMyReservation: Bool = false
    @State private var temporaryReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    //ReservationStore.tempReservation
    
    private let step = 1  // 인원선택 stepper의 step
    private let range = 1...6  // stepper 인원제한
    
    let shopData: Shop
    
    var reservedTimeString: String {
        self.temporaryReservation.time > 11 ? "오후" : "오전"
    }
    
    var reservedTimeInt: Int {
        self.temporaryReservation.time > 12 ? temporaryReservation.time - 12 : temporaryReservation.time
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    
                    // 메뉴마다 이렇게 있을 수 없음.. 식당에서는 예약 아이템을 어떻게 둬야할지
                    ItemInfoView()
                        .padding(.bottom, 20)
                    
                    Text("예약 일시")
                        .font(Font.pretendardBold24)
                    
                    // 버튼의 범위를 HStack 전체로 할지 고민
                    HStack {
                        Image(systemName: "calendar")
                        HStack {
                            Text(reservationStore.getReservationDate(reservationDate: temporaryReservation.date))
                            Text(" / ")
                            Text(isSelectedTime ? self.reservedTimeString + " \(self.reservedTimeInt)시" : "시간") // 오전 /오후 수정
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
                        DateTimePickerView(temporaryReservation: $temporaryReservation, isSelectedTime: $isSelectedTime)
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
                        
                        //                    Text("방문하시는 인원을 선택하세요")
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
                        Button {
                            isShwoingConfirmView.toggle()
                        } label: {
                            Text("다음단계")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .tint(.primary)
                        .background(Color("AccentColor"))
                        .cornerRadius(12)
                        .disabled(!isSelectedTime)
                        
                        Button {
                            isShowingMyReservation.toggle()
                            reservationStore.fetchReservation()
                        } label: {
                            Text("내 예약 보기")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .tint(.primary)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                    }
                    .navigationDestination(isPresented: $isShwoingConfirmView) {
                        ReservationConfirmView(isShwoingConfirmView: $isShwoingConfirmView, temporaryReservation: temporaryReservation, shopData: shopData)
                    }
                    .sheet(isPresented: $isShowingMyReservation) {
                         MyReservation(isShowingMyReservation: $isShowingMyReservation)
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
        ReservationView(shopData: ShopStore.shop)
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
    }
}
