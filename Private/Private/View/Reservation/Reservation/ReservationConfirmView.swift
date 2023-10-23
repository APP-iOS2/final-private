//
//  ReservationConfirmView.swift
//  Private
//
//  Created by 박성훈 on 10/10/23.
//

import SwiftUI

import SwiftUI

struct ReservationConfirmView: View {
    enum Field: Hashable {
        case requirement
    }
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    @State private var isShowRemoveReservationAlert: Bool = false
    @Binding var viewNumber: Int
    
    let reservationData: Reservation  // 예약 데이터
    let shopData: Shop
    
    var body: some View {
        VStack {
            ScrollView {
            VStack(alignment: .leading) {
                Text("예약 정보")
                    .font(.pretendardBold20)
                    .foregroundStyle(Color.privateColor)
                    .padding(.bottom, 2)
                ReservationCardCell(title: "상점", content: shopData.name)
                ReservationCardCell(title: "일시", content: "\(reservationStore.getReservationDate(reservationDate: reservationData.date)) \(reservedTime) \(reservedHour):00")
                ReservationCardCell(title: "인원", content: "\(reservationData.numberOfPeople)명")
                ReservationCardCell(title: "최종 결제할 금액", content: reservationData.priceStr)
            }
            .foregroundStyle(.primary)
            .padding(.bottom, 10)
            PrivateDivder()
            VStack(alignment: .leading) {
                Text("예약자 정보")
                    .font(.pretendardBold20)
                    .foregroundStyle(Color.privateColor)
                    .padding(.bottom, 2)
                
                ReservationCardCell(title: "예약자", content: userStore.user.name)
                ReservationCardCell(title: "이메일", content: userStore.user.email)
                ReservationCardCell(title: "요구사항", content: reservationData.requirementStr)
            }
            .padding(.bottom, 10)
            PrivateDivder()
            VStack(alignment: .leading) {
                Text("판매자 정보")
                    .font(.pretendardBold20)
                    .foregroundStyle(Color.privateColor)
                    .padding(.bottom, 2)
                
                ReservationCardCell(title: "상호", content: shopData.name)
                ReservationCardCell(title: "대표자명", content: shopData.shopOwner)
                ReservationCardCell(title: "소재지", content: shopData.address)
                ReservationCardCell(title: "사업자번호", content: shopData.businessNumber)
            }
        }
            if viewNumber == 0 {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("알립니다")
                        Spacer()
                    }
                    .font(.pretendardBold18)
                    .foregroundColor(Color.privateColor)
                    .padding(.bottom, 6)
                    
                    Text("예약 변경 및 취소는 예약시간 한 시간 전까지 가능합니다")
                        .font(.pretendardRegular16)
                        .foregroundStyle(Color.primary)
                }
                .padding()
                .background(Color.subGrayColor)
                .cornerRadius(12)
                .padding(.bottom)
                
                ReservationButton(text: "예약 취소") {
                    isShowRemoveReservationAlert.toggle()
                }
                .foregroundStyle(Color.black)
                .alert("예약 취소", isPresented: $isShowRemoveReservationAlert) {
                    Button(role: .destructive) {
                        reservationStore.removeReservation(reservation: reservationData)
                        dismiss()
                    } label: {
                        Text("취소하기")
                    }
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("돌아가기")
                    }
                } message: {
                    Text("예약을 취소하시겠습니까?")
                }
            }
        }
        .padding()
        .navigationTitle("예약 내역")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .backButtonArrow()
        .onAppear {
            self.reservedTime = reservationStore.conversionReservedTime(time: reservationData.time).0
            self.reservedHour = reservationStore.conversionReservedTime(time: reservationData.time).1
        }
        
    }
}

struct ReservationConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationConfirmView(viewNumber: .constant(0), reservationData: ReservationStore.tempReservation, shopData: ShopStore.shop)
    }
}
