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
        VStack {
            HStack {
                Text("예약 날짜")
                Spacer()
                Text("\(reservationStore.getReservationDate(reservationDate: reservation.date))")
            }
            
            HStack {
                Text("예약 시간")
                Spacer()
                Text("\(reservation.time)시")
            }
            
            HStack {
                Text("예약 인원")
                Spacer()
                Text("\(reservation.numberOfPeople)명")
            }
            
            HStack {
                Text("예약자 이메일")
                Spacer()
                Text("\(reservation.reservedUserId)")
            }

            HStack {
                Text("총 비용")
                Spacer()
                Text("\(reservation.totalPrice)원")
            }
            
            HStack {
                Button {
                    print(#fileID, #function, #line, "- 예약 수정")
                } label: {
                    Text("예약 수정")
                        .padding()
                }
                .tint(Color.primary)
                .background(Color.yellow)
                
                Button{
                    print(#fileID, #function, #line, "- 예약 취소")
                } label: {
                    Text("예약 취소")
                        .padding()
                }
                .tint(Color.blue)
                .background(Color.red)

            }
        }
        .padding()
        .background(Color.subGrayColor)
    }
}

struct ReservationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationCardView(reservation: ReservationStore.tempReservation)
            .environmentObject(ReservationStore())
    }
}
