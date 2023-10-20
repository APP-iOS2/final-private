//
//  TossPaymentsContentView.swift
//  Private
//
//  Created by 박성훈 on 10/20/23.
//

import SwiftUI
import TossPayments

//private enum Constants {
//    static let clientKey: String = Bundle.main.payment_Client_KEY
//    static let 테스트결제정보: PaymentInfo = DefaultPaymentInfo(
//        amount: 1000,
//        orderId: "9lD0azJWxjBY0KOIumGzH",
//        orderName: "토스 티셔츠 외 2건",
//        customerName: "박토스"
//    )
//}

struct TossPaymentsContentView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    
    @State private var showingSuccess: Bool = false
    @State private var showingFail: Bool = false
    
    @StateObject var viewModel = TossPaymentsContentViewModel()
    
    @Binding var isShowingConfirmView: Bool
    @Binding var isShwoingDetailView: Bool
    @Binding var isReservationPresented: Bool

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
            
            ReservationButton(text: "결제하기") {
                // 여기서 그냥 다른 뷰 띄워야 하나..
                // 네비게이션 다 나가고, 새로운 뷰를 하나 띄워줌
                // 새로운 뷰 위에 토스트 메세지도 뛰워주자
                // 네비게이션 없애기
                dismiss()
                isShwoingDetailView = false
                isReservationPresented = false
                isShowingConfirmView.toggle()

                // 뷰 만들고
                // 토스트 뷰
                
//                viewModel.requestPayment(info: DefaultWidgetPaymentInfo(orderId: "\(TossPaymentsContentViewModel.orderId)", orderName: shopData.name))
            }
            .foregroundStyle(Color.black)
            .padding()
            .alert(isPresented: $showingSuccess, content: {
                Alert(title: Text(verbatim: "Success"), message: Text(verbatim: viewModel.onSuccess?.orderId ?? ""))
            })
            .alert(isPresented: $showingFail, content: {
                Alert(title: Text(verbatim: "Fail"), message: Text(verbatim: viewModel.onFail?.orderId ?? ""))
            })
            .onReceive(viewModel.$onSuccess.compactMap { $0 }) { success in
                showingSuccess = true
            }
            .onReceive(viewModel.$onFail.compactMap { $0 }) { fail in
                showingFail = true
            }
        }
        .background(Color.white)
    }
        
}

struct TossPaymentsContentView_Previews: PreviewProvider {
    static var previews: some View {
        TossPaymentsContentView(isShowingConfirmView: .constant(false), isShwoingDetailView: .constant(true), isReservationPresented: .constant(true), reservationData: ReservationStore.tempReservation, shopData: ShopStore.shop)
            .environmentObject(UserStore())
    }
}
