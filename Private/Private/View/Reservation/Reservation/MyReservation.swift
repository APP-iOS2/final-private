//
//  MyReservation.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI

struct MyReservation: View {
    @EnvironmentObject var reservationStore: ReservationStore
    
    var body: some View {
        VStack {
            ForEach(reservationStore.reservationList, id: \.self) { reservation in
                ReservationCardView(reservation: reservation)
            }
        }
        .padding()
        .onAppear {
            reservationStore.fetchReservation()
        }
        .refreshable {
            reservationStore.fetchReservation()
        }
    }
}

struct MyReservation_Previews: PreviewProvider {
    static var previews: some View {
        MyReservation()
            .environmentObject(ReservationStore())
    }
}
