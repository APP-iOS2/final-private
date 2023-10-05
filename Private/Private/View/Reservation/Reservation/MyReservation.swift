//
//  MyReservation.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI

struct MyReservation: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @Binding var isShowingMyReservation: Bool
    
    let dummyReservationList: [Reservation] = [
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    //                ForEach(reservationStore.reservationList, id: \.self) { reservation in
                    ForEach(dummyReservationList, id: \.self) { reservation in
                        ReservationCardView(reservation: reservation)
                            .padding(.vertical, 6)
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            isShowingMyReservation.toggle()
                        } label: {
                            Text("확인")
                                .font(Font.pretendardMedium20)
                        }
                    }
                }
            }
        }
        //            .onAppear {
        //                dump(reservationStore.reservationList)
        //            }
        //            .refreshable {
        //                reservationStore.fetchReservation()
        //            }
    }
}

struct MyReservation_Previews: PreviewProvider {
    static var previews: some View {
        MyReservation(isShowingMyReservation: Binding.constant(true))
            .environmentObject(ReservationStore())
    }
}
