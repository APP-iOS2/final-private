//
//  TossPaymentsContentView.swift
//  Private
//
//  Created by 박성훈 on 10/20/23.
//

import SwiftUI
import TossPayments

struct TossPaymentsContentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var reservationStore: ReservationStore
    
    @StateObject var viewModel = TossPaymentsContentViewModel()

    @State private var isTappedPaymentsButton: Bool = false
    
    @Binding var isShwoingDetailView: Bool
    @Binding var isReservationPresented: Bool
    
    let reservationData: Reservation
    let shopData: Shop
    
    var body: some View {
        if isTappedPaymentsButton {
            VStack(alignment: .leading) {
                Text("결제 완료")
                    .font(.pretendardBold20)
                    .foregroundStyle(.primary)
                    .padding([.horizontal, .top])
                    .padding(.bottom, 12)
                
                ReservationConfirmView(reservationData: reservationStore.myReservation, shopData: shopData)
                
                Spacer()
                ReservationButton(text: "확인") {
                    dismiss()
                    isShwoingDetailView = false
                    isReservationPresented = false
                }
                .foregroundStyle(Color.black)
                .padding()
            }
            .navigationBarBackButtonHidden(true)
        } else {
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        PaymentMethodWidgetView(widget: viewModel.widget, amount: PaymentMethodWidget.Amount(value: Double(reservationData.totalPrice)))
                        AgreementWidgetView(widget: viewModel.widget)
                    }
                }
                
                HStack {
//                    ReservationButton(text: "돌아가기") {
//                        dismiss()
//                    }
//                    .foregroundStyle(Color.black)
                    
                    ReservationButton(text: "결제하기") {
                        // 파베에 올리기
                        reservationStore.myReservation = reservationData
                        reservationStore.addReservationToFirestore(reservationData: reservationStore.myReservation)
                        
                        isTappedPaymentsButton.toggle()
                    }
                    .foregroundStyle(Color.black)
                }
                .padding()
            }
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .backButtonArrow()
        }

    }
}

struct TossPaymentsContentView_Previews: PreviewProvider {
    static var previews: some View {
        TossPaymentsContentView(isShwoingDetailView: .constant(true), isReservationPresented: .constant(true), reservationData: ReservationStore.tempReservation, shopData: ShopStore.shop)
            .environmentObject(UserStore())
            .environmentObject(ReservationStore())
    }
}
