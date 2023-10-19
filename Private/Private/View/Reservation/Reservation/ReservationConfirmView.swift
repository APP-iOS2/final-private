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
    
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var reservedTime: String = ""
    @State private var reservedHour: Int = 0
    
    let reservationData: Reservation  // 예약 데이터
    let shopData: Shop  // 가게 데이터
    
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
                
                ReservationCardCell(title: "최종 결제할 금액", content: reservationData.priceStr)
                    .padding(.bottom)
                
                Divider()
                    .padding(.bottom, 12)
                
                VStack(alignment: .leading) {
                    Text("예약자 정보")
                        .font(.pretendardMedium20)
                        .padding(.bottom, 2)
                    
                    ReservationCardCell(title: "예약자", content: userStore.user.name)
                    ReservationCardCell(title: "이메일", content: userStore.user.email)
                    ReservationCardCell(title: "요구사항", content: reservationData.requirement ?? "요구사항 없음")
                    
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
            
        }
        
    }
}

struct ReservationConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationConfirmView(reservationData: ReservationStore.tempReservation, shopData: ShopStore.shop)
    }
}
