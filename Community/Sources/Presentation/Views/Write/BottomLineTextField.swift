//
//  BottomLineTextField.swift
//  Hambug
//
//  Created by 강동영 on 10/28/25.
//

import SwiftUI

public struct BottomLineTextField: View {
  @Binding var title: String

  public var body: some View {
    TextField("", text: $title)
      .pretendard(.body(.base))
      .padding(.horizontal, 16)
      .padding(.vertical, 14)
      .overlay(
        Rectangle()
          .frame(height: 1)
          .foregroundColor(Color.borderG400),
        alignment: .bottom
      )
  }
  
  public init(title: Binding<String>) {
    self._title = title
  }
}
