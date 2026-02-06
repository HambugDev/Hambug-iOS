//
//  UIBaseLoginView.swift
//  HambugUITests
//
//  Created by 강동영 on 2/7/26.
//

import XCTest

final class UIBaseLoginView: TestUIBase {
  func login() {
    delay(.medium)
    tap(.kakaoLoginButton)
    
    delay(.medium)
    tap(.popUpContinueButton)
    
    delay(.medium)
    tap(.webViewContinueButton)
    
    delay(.long)
    delay(.long)
    checkExist(.hambugTitleText, isExist: true)
  }
}

extension UIBaseLoginView: UITapAvailable {
  typealias TapAvailables = TapAvailable
  
  enum TapAvailable {
    case kakaoLoginButton
    case popUpContinueButton
    case webViewContinueButton
  }
  
  func tap(_ tap: TapAvailable) {
    guard let app = app else {
      XCTAssert(false, "app 초기화 안됌")
      return
    }
    
    switch tap {
    case .kakaoLoginButton:
      let 카카오로그인 = TestIdentifier.kakaoLoginButton
      app.buttons[카카오로그인].tap()
      
    case .popUpContinueButton:
      XCUIDevice.shared.press(.home)
      let springboardApp = XCUIApplication(bundleIdentifier: TestIdentifier.springboard)
      let 계속 = TestIdentifier.popUpContinueButton
      springboardApp.buttons[계속].tap()
      
    case .webViewContinueButton:
      let safariViewServiceApp = XCUIApplication(bundleIdentifier: TestIdentifier.safariview)
      let 계속하기 = TestIdentifier.webViewContinueButton
      safariViewServiceApp.buttons[계속하기].tap()
    }
  }
}

extension UIBaseLoginView: UICheckExistAvailable {
  typealias CheckExistAvailables = CheckExistAvailable
  
  enum CheckExistAvailable {
    case hambugTitleText
  }
  
  func checkExist(_ object: CheckExistAvailable, isExist: Bool) {
    guard let app = app else {
        XCTAssert(false, "app 초기화 안됌")
        return
    }
    
    switch object {
    case .hambugTitleText:
      let 햄버그 = TestIdentifier.hambugTitleText
      XCTAssert(app.staticTexts[햄버그].exists == isExist)
    }
  }
}
