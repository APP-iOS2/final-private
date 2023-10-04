//
//  ReservationCardView.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI

struct ReservationCardView: View {
    @EnvironmentObject var reservationStore: ReservationStore

    let reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .opacity(0)
            Text("예약 날짜: \(reservationStore.getReservationDate(reservationDate: reservation.date))")
            Text("예약 시간: \(reservation.time)시")
            Text("예약 인원: \(reservation.numberOfPeople)명")
            Text("예약자 이메일: \(reservation.reservedUserId)")
            Text("총 비용: \(reservation.totalPrice)원")
        }
        .padding()
        .background(Color.subGrayColor)
    }
}

struct ReservationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationCardView(reservation: Reservation(shopId: "맛집", reservedUserId: "멋쟁이토마토", date: Date(), time: 18, totalPrice: 30000))
            .environmentObject(ReservationStore())
    }
}
