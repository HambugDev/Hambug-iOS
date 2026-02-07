//
//  View+.swift
//  Hambug
//
//  Created by 강동영 on 8/26/25.
//

import SwiftUI

public extension View {
  // MARK: - font, linespacing 적용되어있음 (기본값: Pretendard)
  func pretendard(_ style: TextStyle) -> some View {
    let pretendardProvider = PretendardProvider()
    let fontStyle = style.getFontStyle(with: pretendardProvider)
    return self
      .font(fontStyle.font)
      .lineSpacing(fontStyle.lineHeight)
  }
  
  func geekbleMalang2(_ size: CGFloat = 24) -> some View {
    let geekbleMalang2Provider = GeekbleMalang2Provider()
    let fontStyle = FontStyle(.custom(geekbleMalang2Provider.regular), size: size)
    return self
      .font(fontStyle.font)
      .lineSpacing(fontStyle.lineHeight)
  }
}
