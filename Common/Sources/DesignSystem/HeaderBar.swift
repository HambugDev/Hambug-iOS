//
//  HeaderBar.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import SwiftUI

// 상단 헤더 - 로고, 알림
public struct HeaderBar: View {
  public init() {}
  
  public var body: some View {
    HStack(spacing: 10) {
      Image("hambug_icon")
        .resizable()
        .frame(width: 30, height: 30)
      
      Text("햄버그")
        .pretendard(.title(.t1))
        .foregroundColor(.primaryHambugRed)
      Spacer()
    }
    .padding()
  }
}

#Preview {
  HeaderBar()
}
