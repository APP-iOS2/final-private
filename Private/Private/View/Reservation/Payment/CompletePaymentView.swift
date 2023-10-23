//
//  CompletePaymentView.swift
//  Private
//
//  Created by 박성훈 on 10/21/23.
//

import SwiftUI

struct CompletePaymentView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    
    let shopData: Shop
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 1)
            ScrollView() {
                LottieView(fileName: "Complete", loopMode: .playOnce)
                    .frame(width: 130, height: 130)
                Text("결제 완료")
                    .font(.pretendardBold24)
                    .foregroundStyle(.primary)
                    .padding(.bottom, 12)
                ReservationConfirmView(viewNumber: .constant(1), reservationData: reservationStore.myReservation, shopData: shopData)
            }
            .scrollIndicators(.hidden)

            ReservationButton(text: "확인") {
                NavigationUtil.popToRootView()
            }
            .foregroundStyle(Color.black)
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct CompletePaymentView_Previews: PreviewProvider {
    static var previews: some View {
        CompletePaymentView(shopData: ShopStore.shop)
    }
}
