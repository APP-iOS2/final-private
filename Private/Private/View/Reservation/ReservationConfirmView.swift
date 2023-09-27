//
//  ReservationConfirmView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/25.
//

import SwiftUI

struct ReservationConfirmView: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @Binding var temporaryReservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Divider()
                    .opacity(0)
                Text("예약 날짜: \(reservationStore.getReservationDate(reservationDate: temporaryReservation.date))")
                Text("예약 시간: \(reservationStore.reservationList[0].time)시")
                Text("예약 인원: \(reservationStore.reservationList[0].numberOfPeople)명")
                Text("총 비용: \(reservationStore.reservationList[0].totalPrice)원")
            }
            .padding()
            .background(Color("SubGrayColor"))
            .cornerRadius(8)
            
            Button {
                print(#fileID, #function, #line, "- 예약 확정 ")
                reservationStore.addReservationToFirestore(reservationData: reservationStore.reservationList[0])
            } label: {
                Text("예약하기")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .tint(.primary)
            .background(Color("AccentColor"))
            .cornerRadius(12)
        }
        .padding()
    }
}

struct ReservationConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationConfirmView(temporaryReservation: .constant(Reservation(shopId: "", reservedUserId: "defstem9@gmail.com", date: Date(), time: -1, numberOfPeople: 1, totalPrice: 30000)))
            .environmentObject(ReservationStore())
    }
}
