//
//  TossPaymentsContentViewModel.swift
//  Private
//
//  Created by 박성훈 on 10/20/23.
//

import SwiftUI
import TossPayments

class TossPaymentsContentViewModel: ObservableObject {
    @EnvironmentObject var userStore: UserStore

    let widget = PaymentWidget(clientKey: Bundle.main.payment_Client_KEY, customerKey: "Test")
    
    @Published
    var isShowing: Bool = false
    
    @Published
    var onSuccess: TossPaymentsResult.Success?
    @Published
    var onFail: TossPaymentsResult.Fail?
    
    init() {
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
