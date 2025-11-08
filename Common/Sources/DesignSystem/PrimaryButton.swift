//
//  PrimaryButton.swift
//  Hambug
//
//  Created by 강동영 on 9/26/25.
//

import SwiftUI

public struct PrimaryButton: View {
  private let titleKey: String
  private let titleStyle: TextStyle
  private let action: @MainActor () -> Void
  
  private var foregroundColor: Color = .white
  private var backgroundColor: Color = .primaryHambugRed
  private var cornerRadius: CGFloat = 15
  
  public var body: some View {
    Button {
      action()
    } label: {
      Text(titleKey)
        .pretendard(titleStyle)
        .foregroundStyle(foregroundColor)
        .frame(maxWidth: .infinity, maxHeight: 53)
        .background(
          RoundedRectangle(cornerRadius: cornerRadius)
            .fill(backgroundColor)
        )
    }
  }
  
  public init(
    title: String,
    style: TextStyle,
    action: @escaping @MainActor () -> Void = {}
  ) {
    self.titleKey = title
    self.titleStyle = style
    self.action = action
  }
}

public extension PrimaryButton {
  func foregroundColor(_ color: Color) -> Self {
    var button = self
    button.foregroundColor = color
    return button
  }
  
  func backgroundColor(_ color: Color) -> Self {
    var button = self
    button.backgroundColor = color
    return button
  }
  
  func cornerRadius(_ value: CGFloat) -> Self {
    var button = self
    button.cornerRadius = value
    return button
  }
}
