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
        VStack(alignment: .leading, spacing: 5) {
            ReservationCardCell(title: "예약 날짜", content: dateToFullString(date: reservation.date))
            ReservationCardCell(title: "예약 시간", content: "\(reservation.time)시")
            ReservationCardCell(title: "예약 인원", content: "\(reservation.numberOfPeople)명")
            ReservationCardCell(title: "예약자 이메일", content: "\(reservation.reservedUserId)")
            ReservationCardCell(title: "총 비용", content: "\(reservation.totalPrice)원")
        }
        .padding()
        .background(Color("SubGrayColor"))
        .cornerRadius(12)
    }
    
    func dateToFullString(date: Date) -> String {
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct ReservationCardView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationCardView(reservation: ReservationStore.tempReservation)
            .environmentObject(ReservationStore())
    }
}

struct ReservationCardCell: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("\(title)")
                .font(Font.pretendardMedium18)
            
            Spacer()
            
            Text("\(content)")
                .font(Font.pretendardMedium16)
        }
    }
}
