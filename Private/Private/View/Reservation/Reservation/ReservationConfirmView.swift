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
    
    @State private var isShowingMyReservation: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Divider()
                    .opacity(0)
                Text("예약 날짜: \(reservationStore.getReservationDate(reservationDate: temporaryReservation.date))")
                Text("예약 시간: \(temporaryReservation.time)시")
                Text("예약 인원: \(temporaryReservation.numberOfPeople)명")
                Text("총 비용: \(temporaryReservation.totalPrice)원")
            }
            .padding()
            .background(Color.subGrayColor)
            .cornerRadius(8)
            
            Button {
                print(#fileID, #function, #line, "- 예약 확정 ")
                reservationStore.addReservationToFirestore(reservationData: temporaryReservation)
                
                // 여기서 뷰 한 번 보여줘보자..!
                isShowingMyReservation.toggle()
            } label: {
                Text("예약하기")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .tint(.primary)
            .background(Color("AccentColor"))
            .cornerRadius(12)
            .sheet(isPresented: $isShowingMyReservation) {
                MyReservation()
            }
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
