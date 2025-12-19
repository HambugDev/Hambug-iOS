//
//  HambugApp.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI
import Managers
import DesignSystem
import KakaoLogin
import AppDI

@main
struct HambugApp: App {
  // Initialize AppDIContainer singleton first
  private let appContainer = AppDIContainer.shared

  // Get AppStateManager from AppDIContainer
  @State private var appStateManager: AppStateManager
  private let kakaoSDK = KakaoSDKManager.shared

  init() {
    // Initialize AppStateManager from DI container
    self._appStateManager = State(initialValue: appContainer.makeAppStateManager())

    FontManager.registerAllFonts()
    kakaoSDK.regist(appKey: HambugApp.kakaoMapNativeKey)
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(appStateManager)
        .environment(appContainer)
        .onOpenURL { url in
          kakaoSDK.authCallback(with: url)
        }
    }

  }
}

extension HambugApp {
  public static let kakaoMapNativeKey: String = {
    guard let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String else {
      print("NATIVE_APP_KEY 에러")
      return ""
    }
    return key
  }()
}
