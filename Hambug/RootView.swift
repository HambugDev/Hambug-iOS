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
import LoginDI
import AppDI
import IntroDI
import NetworkImpl
import Util

struct RootView: View {
  @Environment(AppStateManager.self) var appStateManager
  @Environment(AppDIContainer.self) var appContainer

  var body: some View {
    let _ = Self._printChanges()
    Group {
      switch appStateManager.currentState {
      case .splash:
        SplashView(
          viewModel: IntroDIContainer(
            appContainer: appContainer,
            appStateManager: appStateManager
          ).resolve(SplashViewModel.self)
        )

      case .onboarding:
        OnboardingView(
          viewModel: IntroDIContainer(
            appContainer: appContainer,
            appStateManager: appStateManager
          ).resolve(OnboardingViewModel.self)
        )

      case .login:
        LoginView(
          viewModel: LoginDIContainer(
            appContainer: appContainer,
            appStateManager: appStateManager
          ).makeLoginViewModel()
        )

      case .main:
        ContentView()
      }
    }
    .environment(appContainer)
    .onReceive(NotificationCenter.default.publisher(for: .userDidLogout)) { _ in
      handleLogout()
    }
  }

  @MainActor
  private func handleLogout() {
    appStateManager.logout()
  }
}
