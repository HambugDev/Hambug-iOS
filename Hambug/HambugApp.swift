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

@main
struct HambugApp: App {
  @State private var appStateManager: AppStateManager = HomeDIContainer.shared.makeAppStateManager()
  private let kakaoSDK = KakaoSDKManager.shared
  
  init() {
    FontManager.registerAllFonts()
    kakaoSDK.regist(appKey: HambugApp.kakaoMapNativeKey)
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(appStateManager)
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
