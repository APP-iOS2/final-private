//
//  MyReservation.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI

struct MyReservation: View {
    @EnvironmentObject var reservationStore: ReservationStore
    
//     var body: some View {
//         ScrollView {
//             ForEach(reservationStore.reservationList, id: \.self) { reservation in
//                 ReservationCardView(reservation: reservation)
//             }
//             .padding()
//         }
//        .onAppear {
//            dump(reservationStore.reservationList)
//        }
    let dummyReservationList: [Reservation] = [
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
        Reservation(shopId: "1234-1234-1234", reservedUserId: "5678-5678-5678", date: Date(), time: 10, totalPrice: 100000),
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                //                ForEach(reservationStore.reservationList, id: \.self) { reservation in
                ForEach(dummyReservationList, id: \.self) { reservation in
                    ReservationCardView(reservation: reservation)
                        .padding(.vertical, 6)
                }
                //                .toolbar {
                //                    ToolbarItem(placement: .confirmationAction) {
                //                        Button {
                //
                //                        } label: {
                //                            Text("확인")
                //                                .font(Font.pretendardMedium20)
                //                        }
                //                    }
                //                }
            }
            .padding()
            
            //            .onAppear {
            //                dump(reservationStore.reservationList)
            //            }
            //            .refreshable {
            //                reservationStore.fetchReservation()
            //            }
        }
    }
    
}

struct MyReservation_Previews: PreviewProvider {
    static var previews: some View {
        MyReservation()
            .environmentObject(ReservationStore())
    }
}
