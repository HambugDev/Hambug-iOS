//
//  HeaderBar.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import SwiftUI

// 상단 헤더 - 로고, 알림
public struct HeaderBar: View {
  private let fontStyle: FontStyle
  public init() {
    fontStyle = .init(.custom("GeekbleMalang2-Regular"), size: 24.0)
  }
  
  public var body: some View {
    HStack(spacing: 4) {
      Image("hambug_icon")
        .resizable()
        .frame(width: 30, height: 30)
      
      Text("햄버그")
        .font(fontStyle.font)
        .lineSpacing(fontStyle.lineHeight)
        .foregroundColor(.primaryHambugRed)
      Spacer()
      
      Image("notification")
        .resizable()
        .frame(width: 30, height: 30)
    }
    .padding()
  }
}

#Preview {
  HeaderBar()
}
