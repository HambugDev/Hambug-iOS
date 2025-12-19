//
//  IntroDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 12/18/25.
//

import DIKit
import AppDI
import Splash
import Onboarding
import Managers

// MARK: - Login Assembly
struct IntroAssembly: Assembly {
  private let appStateManager: AppStateManager

  init(appStateManager: AppStateManager) {
    self.appStateManager = appStateManager
  }

  func assemble(container: GenericDIContainer) {
    container.register(OnboardingViewModel.self) { resolver in
      OnboardingViewModel(
        appStateManager: self.appStateManager
      )
    }

    container.register(SplashViewModel.self) { resolver in
      SplashViewModel(
        appStateManager: self.appStateManager
      )
    }
  }
}

// MARK: - Login DI Container
public final class IntroDIContainer {

  // MARK: - Properties
  private let container: GenericDIContainer

  // MARK: - Initialization
  public init(appContainer: AppDIContainer, appStateManager: AppStateManager) {
    self.container = GenericDIContainer(parent: appContainer.baseContainer)
    IntroAssembly(appStateManager: appStateManager).assemble(container: container)
  }

  // MARK: - Factory Methods
  public func resolve<T>(_ type: T.Type) -> T {
    return container.resolve(type)
  }
}
