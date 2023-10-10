//
//  ReservationConfirmView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/25.
//

import SwiftUI

struct ReservationDetailView: View {
    enum Field: Hashable {
        case requirement
    }
    
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var userStore: UserStore
    
    @FocusState private var focusedField: Field?
    
    @State private var isShowingAlert: Bool = false
    @State private var requirementText: String = ""  // TextField의 Text
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    
    @Binding var isShwoingConfirmView: Bool  // 해당 뷰를 내리기 위함
    @Binding var isReservationPresented: Bool  // ReservationView를 내리기 위함
    
    @Binding var reservationData: Reservation  // 예약 데이터
    let shopData: Shop  // 가게 데이터
    let placeholder: String = "업체에 요청하실 내용을 적어주세요"
    let limitChar: Int = 100

    var body: some View {
        VStack {
            ScrollView {
                Text(shopData.name)
                    .font(.pretendardBold24)
                    .padding(.bottom, 12)
                
                Divider()
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("일시:")
                        Text("\(reservationStore.getReservationDate(reservationDate: reservationData.date))")
                        Text("\(reservedTime) \(reservedHour):00")
                        Spacer()
                    }
                    Text("인원: \(reservationData.numberOfPeople)명")
                }
                .padding()
                .background(Color.subGrayColor)
                .cornerRadius(8)
                .padding(.bottom)
                
                ReservationCardCell(title: "최종 결제할 금액", content: "\(reservationData.numberOfPeople) 원")
                    .padding(.bottom)
                
                Divider()
                    .padding(.bottom, 12)
                
                VStack(alignment: .leading) {
                    Text("예약자 정보")
                        .font(.pretendardMedium20)
                        .padding(.bottom, 2)
                    
                    ReservationCardCell(title: "예약자", content: userStore.user.name)
                    ReservationCardCell(title: "이메일", content: userStore.user.email)
                    
                    Text("요구사항")
                    
                    // TextEditor 부분
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $requirementText)
                            .foregroundStyle(.primary)
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
//                    .onTapGesture {
//                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                    }
                    
                }
                .padding(.bottom)
                
                Divider()
                    .padding(.bottom, 12)
                
                VStack(alignment: .leading) {
                    Text("판매자 정보")
                        .font(.pretendardMedium20)
                        .padding(.bottom, 2)
                    
                    ReservationCardCell(title: "상호", content: shopData.name)
                    ReservationCardCell(title: "대표자명", content: shopData.shopOwner)
                    ReservationCardCell(title: "소재지", content: shopData.address)
                    ReservationCardCell(title: "사업자번호", content: shopData.businessNumber)
                }
            }
            .padding()
            .onAppear {
                guard let email = ReservationStore.user?.email else {
                    return
                }
                userStore.fetchCurrentUser(userEmail: email)
                
                self.reservedTime = reservationStore.conversionReservedTime(time: reservationData.time).0
                self.reservedHour = reservationStore.conversionReservedTime(time: reservationData.time).1
            }
            
            Button {
                isShowingAlert.toggle()
            } label: {
                Text("예약하기")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .tint(.primary)
            .background(Color("AccentColor"))
            .cornerRadius(12)
            .padding()
            .alert("예약 확정", isPresented: $isShowingAlert) {
                Button() {
                    print(#fileID, #function, #line, "- 예약 확정")
                    reservationData.requirement = requirementText
                    reservationStore.addReservationToFirestore(reservationData: reservationData)
                    isShwoingConfirmView.toggle()
                    isReservationPresented.toggle()
                } label: {
                    Text("예약하기")
                }
                
                Button(role: .cancel) {
                    
                } label: {
                    Text("돌아가기")
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct ReservationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationDetailView(isShwoingConfirmView: .constant(true), isReservationPresented: .constant(true), reservationData: .constant(ReservationStore.tempReservation), shopData: ShopStore.shop)
            .environmentObject(ReservationStore())
            .environmentObject(UserStore())
    }
}
