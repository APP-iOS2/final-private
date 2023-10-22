//
//  TossPaymentsContentView.swift
//  Private
//
//  Created by 박성훈 on 10/20/23.
//

import SwiftUI
import TossPayments
import Lottie

struct TossPaymentsView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reservationStore: ReservationStore
    @StateObject var viewModel = TossPaymentsContentViewModel()
    
    let reservationData: Reservation
    let shopData: Shop
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    PaymentMethodWidgetView(widget: viewModel.widget, amount: PaymentMethodWidget.Amount(value: Double(reservationData.totalPrice)))
                    AgreementWidgetView(widget: viewModel.widget)
                }
            }
            
            NavigationLink {
                CompletePaymentView(shopData: shopData)
            } label: {
                Text("결제하기")
                    .font(.pretendardBold18)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .simultaneousGesture(TapGesture().onEnded{
                reservationStore.myReservation = reservationData
                reservationStore.addReservationToFirestore(reservationData: reservationStore.myReservation)
            })
            .foregroundStyle(Color.black)
            .background(Color.privateColor)
            .cornerRadius(12)
            .padding()
            .navigationBarBackButtonHidden(true)
            .backButtonArrow()
        }
        .background(Color.white)
    }
}

struct TossPaymentsContentView_Previews: PreviewProvider {
    static var previews: some View {
        TossPaymentsView(reservationData: ReservationStore.tempReservation, shopData: ShopStore.shop)
            .environmentObject(UserStore())
            .environmentObject(ReservationStore())
    }
}
