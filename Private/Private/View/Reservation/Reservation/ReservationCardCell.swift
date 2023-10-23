//
//  ReservationCardCell.swift
//  Private
//
//  Created by 박성훈 on 10/23/23.
//

import SwiftUI

struct ReservationCardCell: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("\(title): ")
                .font(.pretendardSemiBold16)
            Spacer()
            Text("\(content)")
                .font(.pretendardMedium16)
//            Spacer()
        }
        .foregroundStyle(Color.primary)
        .padding(.bottom, 0.5)
    }
}

struct ReservationCardCell_Previews: PreviewProvider {
    static var previews: some View {
        ReservationCardCell(title: "예약자", content: "Private")
    }
}
