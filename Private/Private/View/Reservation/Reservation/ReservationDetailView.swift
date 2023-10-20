//
//  ReservationConfirmView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/25.
//

import SwiftUI

struct ReservationDetailView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var isShowingAlert: Bool = false
    @State private var requirementText: String = ""  // TextField의 Text
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    
    @Binding var isShwoingDetailView: Bool  // 해당 뷰를 내리기 위함
    @Binding var isReservationPresented: Bool  // ReservationView를 내리기 위함
    @Binding var reservationData: Reservation  // 예약 데이터
    
    let shopData: Shop  // 가게 데이터

    var body: some View {
        VStack {
            ScrollView {
                Text(shopData.name)
                    .font(.pretendardBold24)
                    .foregroundStyle(.white)
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
                    .font(.pretendardRegular16)
                    .foregroundStyle(.white)
                    
                    Text("인원: \(reservationData.numberOfPeople)명")
                        .font(.pretendardRegular16)
                        .foregroundStyle(.white)
                }
                .padding()
                .background(Color.subGrayColor)
                .cornerRadius(8)
                .padding(.bottom)
                
                ReservationCardCell(title: "최종 결제할 금액", content: reservationData.priceStr)
                    .padding(.bottom)
                
                Divider()
                    .padding(.bottom, 12)
                
                VStack(alignment: .leading) {
                    Text("예약자 정보")
                        .font(.pretendardMedium20)
                        .foregroundStyle(Color.privateColor)
                        .padding(.bottom, 2)
                    
                    ReservationCardCell(title: "예약자", content: userStore.user.name)
                    ReservationCardCell(title: "이메일", content: userStore.user.email)
                    
                    Text("요구사항")
                    RequirementTextEditor(requirementText: $requirementText)
                }
                .padding(.bottom)
                
                Divider()
                    .padding(.bottom, 12)
                
                VStack(alignment: .leading) {
                    Text("판매자 정보")
                        .font(.pretendardMedium20)
                        .foregroundStyle(Color.privateColor)
                        .padding(.bottom, 2)
                    
                    ReservationCardCell(title: "상호", content: shopData.name)
                    ReservationCardCell(title: "대표자명", content: shopData.shopOwner)
                    ReservationCardCell(title: "소재지", content: shopData.address)
                    ReservationCardCell(title: "사업자번호", content: shopData.businessNumber)
                }
            }
            .padding()
            .onAppear {
                self.reservedTime = reservationStore.conversionReservedTime(time: reservationData.time).0
                self.reservedHour = reservationStore.conversionReservedTime(time: reservationData.time).1
            }
            
            NavigationLink {
                TossPaymentsContentView(isShwoingDetailView: $isShwoingDetailView, isReservationPresented: $isReservationPresented, reservationData: reservationData, shopData: shopData)
            } label: {
                Text("결제하러 가기")
                    .font(.pretendardBold18)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .foregroundStyle(Color.black)
            .background(Color.privateColor)
            .cornerRadius(12)
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .backButtonArrow()
        
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct ReservationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationDetailView(isShwoingDetailView: .constant(true), isReservationPresented: .constant(true), reservationData: .constant(ReservationStore.tempReservation), shopData: ShopStore.shop)
            .environmentObject(ReservationStore())
            .environmentObject(UserStore())
    }
}
