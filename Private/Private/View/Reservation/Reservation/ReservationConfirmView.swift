//
//  ReservationConfirmView.swift
//  Private
//
//  Created by 박성훈 on 2023/09/25.
//

import SwiftUI

struct ReservationConfirmView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var reservationStore: ReservationStore
    
    @State private var isShowingAlert: Bool = false
    @Binding var temporaryReservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                      .font(.title)
                      .foregroundColor(.white)
                      .padding(20)
                }
                
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
                isShowingAlert.toggle()
            } label: {
                Text("예약하기")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .tint(.primary)
            .background(Color("AccentColor"))
            .cornerRadius(12)
            .alert("예약을 확정합니다.", isPresented: $isShowingAlert) {
                Button(role: .none) {
                    print(#fileID, #function, #line, "- 예약 확정")
                    reservationStore.addReservationToFirestore(reservationData: temporaryReservation)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("예약하기")
                }
                
                Button(role: .cancel) {
                    
                } label: {
                    Text("취소하기")
                }


            } message: {
                Text("예약을 확정짓습니다")
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
