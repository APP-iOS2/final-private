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
    
    @State private var requirementText: String = ""  // TextField의 Text
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    
    @Binding var reservationData: Reservation  // 예약 데이터
    let shopData: Shop  // 가게 데이터
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("예약 정보")
                        .font(.pretendardBold20)
                        .foregroundStyle(Color.privateColor)
                        .padding(.bottom, 8)
                    ReservationCardCell(title: "상점", content: shopData.name)
                    ReservationCardCell(title: "일시", content: "\(reservationStore.getReservationDate(reservationDate: reservationData.date)) \(reservedTime) \(reservedHour):00")
                    ReservationCardCell(title: "인원", content: "\(reservationData.numberOfPeople)명")
                    ReservationCardCell(title: "최종 결제할 금액", content: reservationData.priceStr)
                }
                .foregroundStyle(.primary)
                PrivateDivder()
                VStack(alignment: .leading) {
                    Text("예약자 정보")
                        .font(.pretendardBold20)
                        .foregroundStyle(Color.privateColor)
                        .padding(.bottom, 8)
                    
                    ReservationCardCell(title: "예약자", content: userStore.user.name)
                    ReservationCardCell(title: "이메일", content: userStore.user.email)
                    
                    Text("요구사항")
                        .font(.pretendardSemiBold16)
                        .foregroundStyle(Color.primary)
                    RequirementTextEditor(requirementText: $requirementText)
                }
                PrivateDivder()
                VStack(alignment: .leading) {
                    Text("판매자 정보")
                        .font(.pretendardBold20)
                        .foregroundStyle(Color.privateColor)
                        .padding(.bottom, 8)
                    
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
                TossPaymentsView(reservationData: reservationData, shopData: shopData)
            } label: {
                Text("다음단계")
                    .font(.pretendardBold18)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .simultaneousGesture(TapGesture().onEnded{
                reservationData.requirement = self.requirementText
                
            })
            .foregroundStyle(Color.black)
            .background(Color.privateColor)
            .cornerRadius(12)
            .padding()
        }
        .scrollIndicators(.hidden)
        .navigationTitle("예약")  // 없애던가 남기던가~
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
        ReservationDetailView(reservationData: .constant(ReservationStore.tempReservation), shopData: ShopStore.shop)
            .environmentObject(ReservationStore())
            .environmentObject(UserStore())
    }
}
