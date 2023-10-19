//
//  ModifyReservationView.swift
//  Private
//
//  Created by 박성훈 on 10/10/23.
//

import SwiftUI

struct ModifyReservationView: View {
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var calendarData: CalendarData

    @State private var showingDate: Bool = false    // 예약 일시 선택
    @State private var showingNumbers: Bool = false // 예약 인원 선택
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    @State private var isShowingAlert: Bool = false
    @State private var requirementText: String = ""
    
    @Binding var temporaryReservation: Reservation
    @Binding var isShowModifyView: Bool
    
    private let step = 1  // 인원선택 stepper의 step
    private let range = 1...6  // stepper 인원제한
    
    let shopData: Shop
    
    var body: some View {
        ScrollView {
            Text(shopData.name)
                .font(.pretendardBold24)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("예약 일시")
                    .font(.pretendardBold18)
                
                HStack {
                    Image(systemName: "calendar")
                    Text(reservationStore.getReservationDate(reservationDate: calendarData.selectedDate))
                    Text(" / ")
                    Text(self.reservedTime + " \(self.reservedHour)시")
                    Spacer()
                    
                    Button {
                        showingDate.toggle()
                    } label: {
                        Image(systemName: showingDate ? "chevron.up.circle": "chevron.down.circle")
                    }
                }
                .font(.pretendardMedium18)
                .padding()
                .background(Color("SubGrayColor"))
                .cornerRadius(12)
                .padding(.bottom)
                
                if showingDate {
                    DateTimePickerView(temporaryReservation: $temporaryReservation, isSelectedTime: .constant(true), shopData: shopData)
                        .onChange(of: temporaryReservation.time) { newValue in
                            self.reservedTime = reservationStore.conversionReservedTime(time: newValue).0
                            self.reservedHour = reservationStore.conversionReservedTime(time: newValue).1
                        }
                }
                
                Text("인원")
                    .font(.pretendardBold18)
                
                HStack {
                    Image(systemName: "person")
                    Text(String(temporaryReservation.numberOfPeople) + "명")
                    Spacer()
                    Button {
                        showingNumbers.toggle()
                    } label: {
                        Image(systemName: showingNumbers ? "chevron.up.circle": "chevron.down.circle")
                    }
                }
                .font(.pretendardMedium18)
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
                
                Text("요구사항")
                RequirementTextEditor(requirementText: $requirementText)
                    .padding(.bottom)
                
                ReservationButton(text: "예약 변경하기") {
                    isShowingAlert.toggle()
                }
                .tint(.primary)
                .alert("예약 변경", isPresented: $isShowingAlert) {
                    Button() {
                        print(#fileID, #function, #line, "- 예약 확정")
                        temporaryReservation.date = calendarData.selectedDate
                        temporaryReservation.requirement = requirementText
                        reservationStore.updateReservation(reservation: temporaryReservation)
                        isShowModifyView.toggle()
                    } label: {
                        Text("변경하기")
                    }
                    
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("돌아가기")
                    }
                }
            }
        }
//        .onTapGesture {
//            hideKeyboard()
//            print(#fileID, #function, #line, "- OnTabGesture")
//        }
        .padding()
        .onAppear {
            calendarData.selectedDate = temporaryReservation.date
            calendarData.currentPage = temporaryReservation.date
            calendarData.titleOfMonth = temporaryReservation.date
            
            self.reservedTime = reservationStore.conversionReservedTime(time: temporaryReservation.time).0
            self.reservedHour = reservationStore.conversionReservedTime(time: temporaryReservation.time).1
            if let requirement = temporaryReservation.requirement {
                self.requirementText = requirement
            }
        }
    }
}

struct ModifyReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyReservationView(temporaryReservation: .constant(ReservationStore.tempReservation), isShowModifyView: .constant(true), shopData: ShopStore.shop)
            .environmentObject(ShopStore())
            .environmentObject(ReservationStore())
    }
}
