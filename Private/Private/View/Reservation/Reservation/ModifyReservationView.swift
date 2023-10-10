//
//  ModifyReservationView.swift
//  Private
//
//  Created by 박성훈 on 10/10/23.
//

import SwiftUI

struct ModifyReservationView: View {
    enum Field: Hashable {
        case requirement
    }
    
    @FocusState private var focusedField: Field?
    
    @EnvironmentObject var shopStore: ShopStore
    @EnvironmentObject var reservationStore: ReservationStore
    
    @State private var showingDate: Bool = false    // 예약 일시 선택
    @State private var showingNumbers: Bool = false // 예약 인원 선택
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    @State private var temporaryReservation: Reservation = Reservation(shopId: "", reservedUserId: "유저정보 없음", date: Date(), time: 23, totalPrice: 30000)
    @State private var isShowingAlert: Bool = false
    
    @State private var requirementText: String = ""
    
    @Binding var isShowModifyView: Bool
    
    private let step = 1  // 인원선택 stepper의 step
    private let range = 1...6  // stepper 인원제한
    
    let placeholder: String = "업체에 요청하실 내용을 적어주세요"
    let limitChar: Int = 100
    
    var reservationData: Reservation
    
    var body: some View {
        ScrollView {
            Text("예약 수정")
                .font(.pretendardBold24)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("예약 일시")
                    .font(Font.pretendardBold18)
                
                HStack {
                    Image(systemName: "calendar")
                    HStack {
                        Text(reservationStore.getReservationDate(reservationDate: temporaryReservation.date))
                        Text(" / ")
                        Text(self.reservedTime + " \(self.reservedHour)시")
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
                    DateTimePickerView(temporaryReservation: $temporaryReservation, isSelectedTime: .constant(true))
                        .onChange(of: temporaryReservation.time) { newValue in
                            self.reservedTime = reservationStore.conversionReservedTime(time: newValue).0
                            self.reservedHour = reservationStore.conversionReservedTime(time: newValue).1
                        }
                }
                
                Text("인원")
                    .font(Font.pretendardBold24)
                
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
                
                Text("요구사항")
                
                // TextEditor 부분
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $requirementText)
                        .foregroundStyle(.primary)  // 수정필요
                        .keyboardType(.default)
                        .frame(height: 80)
                        .lineSpacing(10)
                        .focused($focusedField, equals: .requirement)
                        .onChange(of: self.requirementText, perform: {
                            if $0.count > limitChar {
                                self.requirementText = String($0.prefix(limitChar))
                            }
                        })
                        .border(.secondary)
                    
                    if requirementText.isEmpty {
                        Text(placeholder)
                            .lineSpacing(10)
                            .foregroundColor(Color.primary.opacity(0.25))
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            .onTapGesture {
                                self.focusedField = .requirement
                            }
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                Button {
                    isShowingAlert.toggle()
                } label: {
                    Text("예약 변경하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .tint(.primary)
                .background(Color("AccentColor"))
                .cornerRadius(12)
                .padding()
                .alert("예약 변경", isPresented: $isShowingAlert) {
                    Button() {
                        print(#fileID, #function, #line, "- 예약 확정")
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
        .onAppear {
            self.temporaryReservation = reservationData
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
        ModifyReservationView(isShowModifyView: .constant(true), reservationData: ReservationStore.tempReservation)
    }
}
