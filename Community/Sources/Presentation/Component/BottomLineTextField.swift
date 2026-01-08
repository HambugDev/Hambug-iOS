//
//  BottomLineTextField.swift
//  Hambug
//
//  Created by 강동영 on 10/28/25.
//

import SwiftUI

public struct BottomLineTextField<Field: Hashable>: View {
  @Binding var title: String
  var focusedField: FocusState<Field?>.Binding?
  var field: Field?

  public var body: some View {
    let textField = TextField("", text: $title)
      .pretendard(.body(.base))
      .padding(.horizontal, 16)
      .padding(.vertical, 14)
      .overlay(
        Rectangle()
          .frame(height: 1)
          .foregroundColor(Color.borderG400),
        alignment: .bottom
      )

    if let focusedField = focusedField, let field = field {
      textField.focused(focusedField, equals: field)
    } else {
      textField
    }
  }

  public init(
    title: Binding<String>,
    focusedField: FocusState<Field?>.Binding? = nil,
    field: Field? = nil
  ) {
    self._title = title
    self.focusedField = focusedField
    self.field = field
  }
}
