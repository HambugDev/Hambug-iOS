//
//  RequiredText.swift
//  Community
//
//  Created by 강동영 on 1/8/26.
//

import SwiftUI

struct RequiredText: View {
  private let title: String
  
  init(_ title: String) {
    self.title = title
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Text(title)
        .pretendard(.body(.bEmphasis))
        .foregroundColor(.textG900)
      Text("*")
        .pretendard(.body(.bEmphasis))
        .foregroundColor(.primaryHambugRed)
    }
  }
}
