//
//  HambugApp.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI
import Managers
import DesignSystem
import Splash
import Onboarding

// iOS SDK
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct HambugApp: App {
  @State private var appStateManager: AppStateManager = DIContainer.shared.makeAppStateManager()

  init() {
    FontManager.registerAllFonts()
    KakaoSDK.initSDK(appKey: HambugApp.kakaoMapNativeKey)
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .environment(appStateManager)
        .onOpenURL { url in
          if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        }
    }

  }
}

fileprivate struct RootView: View {
  @Environment(AppStateManager.self) var appStateManager

  var body: some View {
    let _ = Self._printChanges()
    Group {
      switch appStateManager.currentState {
      case .splash:
        SplashView()

      case .onboarding:
        OnboardingView()

      case .login:
        LoginView(viewModel: DIContainer.shared.loginViewModel(appStateManager: appStateManager))

      case .main:
        ContentView()
      }
    }
    .environment(appStateManager)
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
