//
//  TestUIBase.swift
//  Hambug
//
//  Created by 강동영 on 2/7/26.
//

import XCTest

class TestUIBase: XCTestCase {
  static var launched = false
  
  var app: XCUIApplication?
  
  convenience init(app: XCUIApplication?) {
    self.init()
    self.app = app
  }
  
  override func setUp() {
    super.setUp()
    // 앱 Launch 여부(시간 단축용)
    if TestUIBase.launched == false {
      initApp(withLaunch: true)
      TestUIBase.launched = true
    } else {
      initApp(withLaunch: false)
    }
  }
  
  private func initApp(withLaunch: Bool) {
    guard app == nil else { return }
    let application = XCUIApplication()
    if withLaunch {
      application.launchArguments.append("UITest")
      application.launch()
    }
    app = application
  }
  
  override func tearDown() {
    super.tearDown()
    if let cnt = testRun?.failureCount, cnt > 0 {
      // 한번이라도 실패시 다시 Launch토록 설정
      TestUIBase.launched = false
    }
  }
  
  enum DelayType: TimeInterval {
    case short = 0.7
    case medium = 1.3
    case long = 1.6
  }
  
  /// 딜레이 걸기
  func delay(_ timeout: TimeInterval) {
    wait(for: [.delay], timeout: timeout)
  }
  func delay(_ type: DelayType) {
    wait(for: [.delay], timeout: type.rawValue)
  }
  
  /// 스크린샷
  func takeScreenshot(name: String) {
    let fullScreenshot = XCUIScreen.main.screenshot()
    let screenshot = XCTAttachment(uniformTypeIdentifier: "public.png", name: "Screenshot-\(name)-\(UIDevice.current.name).png", payload: fullScreenshot.pngRepresentation, userInfo: nil)
    screenshot.lifetime = .keepAlways
    add(screenshot)
  }
}
