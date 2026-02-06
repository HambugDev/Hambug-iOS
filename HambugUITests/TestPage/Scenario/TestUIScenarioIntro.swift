//
//  TestUIScenarioIntro.swift
//  HambugUITests
//
//  Created by 강동영 on 2/7/26.
//

import XCTest

class TestUIScenarioOnboarding: TestUIBase {
  func testOnboarding() {
    let onboardingView = UIBaseOnboardingView(app: app)
    onboardingView.startOnboarding()
  }
}

class TestUIScenarioLogin: TestUIBase {
  func testKakaoLogin() {
    let onboardingView = UIBaseOnboardingView(app: app)
    onboardingView.startOnboarding()
    let loginView = UIBaseLoginView(app: app)
    loginView.login()
  }
}
