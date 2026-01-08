//
//  View+Keyboard.swift
//  Hambug
//
//  Created by 강동영 on 1/8/26.
//

import SwiftUI

public extension View {
  /// 뷰의 빈 영역을 탭하면 키보드를 해제합니다
  func dismissKeyboardOnTap() -> some View {
    self.onTapGesture {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
      )
    }
  }
}
