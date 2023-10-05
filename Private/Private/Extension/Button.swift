//
//  Button.swift
//  Private
//
//  Created by 박범수 on 10/5/23.
//

import Foundation
import SwiftUI

struct InsetRoundScaleButton: ButtonStyle {
  var labelColor = Color.white
  var backgroundColor = Color.blue
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(labelColor)
      .padding(.init(20))
      .background(Capsule().fill(backgroundColor))
      .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
  }
}
