//
//  MyReservation.swift
//  Private
//
//  Created by 박성훈 on 10/3/23.
//

import SwiftUI

struct MyReservation: View {
    @EnvironmentObject var reservationStore: ReservationStore
    @EnvironmentObject var shopStore: ShopStore
    
    @Binding var isShowingMyReservation: Bool
        
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(reservationStore.reservationList, id: \.self) { reservation in
                        ReservationCardView(reservation: reservation)
                    }
                    .padding()
                }
                .padding()
                .onAppear {
                    reservationStore.fetchReservation()
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            isShowingMyReservation.toggle()
                        } label: {
                            Text("확인")
                                .font(.pretendardMedium20)
                        }
                    }
                }
            }
        }
    }
}

struct MyReservation_Previews: PreviewProvider {
    static var previews: some View {
        MyReservation(isShowingMyReservation: Binding.constant(true))
            .environmentObject(ReservationStore())
            .environmentObject(ShopStore())
    }
}
