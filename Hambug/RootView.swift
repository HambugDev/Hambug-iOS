//
//  RootView.swift
//  Hambug
//
//  Created by 강동영 on 12/17/25.
//

import SwiftUI

import Managers
import Splash
import Onboarding
import LoginPresentation

struct RootView: View {
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
        ViewFactory().makeView()
//        LoginView(viewModel: DIContainer.shared.loginViewModel(appStateManager: appStateManager))
        Text("")

      case .main:
        ContentView()
      }
    }
    .environment(appStateManager)
  }
}
