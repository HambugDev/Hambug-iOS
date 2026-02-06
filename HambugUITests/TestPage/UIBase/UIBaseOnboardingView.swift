//
//  UIBaseOnboardingView.swift
//  Hambug
//
//  Created by 강동영 on 2/7/26.
//

import XCTest

final class UIBaseOnboardingView: TestUIBase {
  func startOnboarding() {
    delay(.medium)
    tap(.allowNotificationButton)
    
    delay(.medium)
    
    tap(.nextButton)
    delay(.medium)
    tap(.nextButton)
    delay(.medium)
    tap(.nextButton)
    delay(.medium)
  }
}

extension UIBaseOnboardingView: UITapAvailable {
  typealias TapAvailables = TapAvailable
  
  enum TapAvailable {
    case nextButton
    case allowNotificationButton
  }
  
  func tap(_ tap: TapAvailable) {
    guard let app = app else {
      XCTAssert(false, "app 초기화 안됌")
      return
    }
    switch tap {
    case .nextButton:
      let 다음 = TestIdentifier.nextButton
      app.buttons[다음].tap()
      
    case .allowNotificationButton:
      let springboardApp = XCUIApplication(bundleIdentifier: TestIdentifier.springboard)
      let 허용 = TestIdentifier.allowNotificationButton
      springboardApp.buttons[허용].tap()
    }
  }
}
