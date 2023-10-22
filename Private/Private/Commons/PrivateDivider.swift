//
//  PrivateDivider.swift
//  Private
//
//  Created by 박성훈 on 10/22/23.
//

import SwiftUI

struct PrivateDivder: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 1)
            .padding(.vertical)
            .opacity(0.6)
    }
}
