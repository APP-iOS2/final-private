//
//  ReservationConfirmView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/25.
//

import SwiftUI

struct ReservationConfirmView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    
    let reservationDate: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .opacity(0)
            Text("예약 날짜: \(reservationStore.getReservationDate())")
            Text("예약 시간: \(reservationStore.reservationList[0].time)시")
            Text("예약 인원: \(reservationStore.reservationList[0].numberOfPeople)명")
            Text("총 비용: \(reservationStore.reservationList[0].totalPrice)원")
        }
        .padding()
        .background(Color("SubGrayColor"))
        .cornerRadius(8)
    }
}

struct ReservationConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationConfirmView(reservationDate: "오늘")
            .environmentObject(ReservationStore())
    }
}
