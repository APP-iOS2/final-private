//
//  ReservationConfirmView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/25.
//

import SwiftUI

struct ReservationConfirmView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var isShowingAlert: Bool = false
    
    @Binding var isShwoingConfirmView: Bool
    
    let temporaryReservation: Reservation
    let shopData: Shop
    
    var reservedTimeString: String {
        self.temporaryReservation.time > 11 ? "오후" : "오전"
    }
    
    var reservedTimeInt: Int {
        self.temporaryReservation.time > 12 ? temporaryReservation.time - 12 : temporaryReservation.time
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Text(shopData.name)
                    .font(.pretendardBold24)
                    .padding(.bottom, 12)
                
                Divider()
                    .padding(.bottom)
                
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("일시:")
                            Text("\(reservationStore.getReservationDate(reservationDate: temporaryReservation.date))")
                            Text("\(reservedTimeString) \(reservedTimeInt)시")  // 오후 2:00 요런느낌
                            Spacer()
                        }
                        Text("인원: \(temporaryReservation.numberOfPeople)명")
                    }
                    .padding()
                    .background(Color.subGrayColor)
                    .cornerRadius(8)
                    .padding(.bottom)
                    
                    HStack {
                        Text("최종 결제할 금액")
                        Spacer()
                        Text("\(temporaryReservation.numberOfPeople) 원")
                    }
                    .padding(.bottom)
                }
                
                Divider()
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    Text("예약자 정보")
                        .font(.pretendardMedium20)
                        .padding(.bottom, 2)
                    
                    HStack {
                        Text("예약자")
                        Spacer()
                        Text(userStore.user.name)
                    }
                    
                    HStack {
                        Text("이메일")
                        Spacer()
                        Text(userStore.user.email)
                    }
                    
                    HStack {
                        Text("요구사항")
                        Spacer()
                        Text("업체에 요청하실 내용을 적어주세요")  // 텍스트필드로 변경
                    }
                }
                .padding(.bottom)
                
                Divider()
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    
                    Text("판매자 정보")
                        .font(.pretendardMedium20)
                        .padding(.bottom, 2)
                    
                    HStack {
                        Text("상호")
                        Spacer()
                        Text(shopData.name)
                    }
                    
                    HStack {
                        Text("대표자명")
                        Spacer()
                        Text(shopData.shopOwner)
                        
                    }
                    
                    HStack {
                        Text("소재지")
                        Spacer()
                        Text(shopData.address)
                    }
                    
                    HStack {
                        Text("사업자번호")
                        Spacer()
                        Text(shopData.businessNumber)
                    }
                }
                
            }
            .padding()
            .onAppear {
                guard let email = ReservationStore.user?.email else {
                    return
                }
                userStore.fetchCurrentUser(userEmail: email)
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
                    reservationStore.addReservationToFirestore(reservationData: temporaryReservation)
                    isShwoingConfirmView.toggle()
                } label: {
                    Text("예약하기")
                }
                
                Button(role: .cancel) {
                    
                } label: {
                    Text("돌아가기")
                }
                .foregroundStyle(Color.red)
            }
        }
    }
}

struct ReservationConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationConfirmView(isShwoingConfirmView: .constant(true), temporaryReservation: ReservationStore.tempReservation, shopData: ShopStore.shop)
            .environmentObject(ReservationStore())
            .environmentObject(UserStore())
    }
}
