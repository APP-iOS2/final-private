//
//  ReservationConfirmView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/25.
//

import SwiftUI

struct ReservationConfirmView: View {
    @ObservedObject var reservationStore: ReservationStore

    let reserv = ReservationStore.reservation  // 더미데이터 사용
    let reservationDate: String
    
    var body: some View {
        VStack {
            Text("예약 날짜: \(reservationStore.getReservationDate())")
            Text("예약 시간: \(reserv.time)시")
            Text("예약 인원: \(reserv.numberOfPeople)명")
            Text("총 비용: \(reserv.totalPrice)원")
        }
    }
}

struct ReservationConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationConfirmView(reservationStore: ReservationStore(), reservationDate: "오늘")
    }
}
