//
//  TossPaymentsContentViewModel.swift
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


class TossPaymentsContentViewModel: ObservableObject {
    @EnvironmentObject var userStore: UserStore

    let widget = PaymentWidget(clientKey: Bundle.main.payment_Client_KEY, customerKey: UUID().uuidString)
    static var orderId: Int = 1
    
    @Published
    var isShowing: Bool = false
    
    @Published
    var onSuccess: TossPaymentsResult.Success?
    @Published
    var onFail: TossPaymentsResult.Fail?
    
    init() {
        Self.orderId += 1
        widget.delegate = self
    }
    func requestPayment(info: WidgetPaymentInfo) {
        widget.requestPayment(
            info: DefaultWidgetPaymentInfo(orderId: "123", orderName: "test")
        )
    }
}
                              
extension TossPaymentsContentViewModel: TossPaymentsDelegate {
    func handleSuccessResult(_ success: TossPaymentsResult.Success) {
        onSuccess = success
    }
    
    func handleFailResult(_ fail: TossPaymentsResult.Fail) {
        onFail = fail
    }
}
