//
//  IntroDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 12/18/25.
//

import DIKit
import IntroPresentation
import Managers

// MARK: - Login Assembly
struct IntroAssembly: Assembly {
  func assemble(container: GenericDIContainer) {
    container.register(OnboardingViewModel.self) { resolver in
      OnboardingViewModel(
        appStateManager: resolver.resolve(AppStateManager.self)
      )
    }

    container.register(SplashViewModel.self) { resolver in
      SplashViewModel(
        appStateManager: resolver.resolve(AppStateManager.self)
      )
    }
  }
}

// MARK: - Login DI Container
public final class IntroDIContainer {

  // MARK: - Properties
  private let container: GenericDIContainer

  // MARK: - Initialization
  public init(appContainer: GenericDIContainer) {
    self.container = appContainer
    IntroAssembly().assemble(container: container)
  }

  // MARK: - Factory
  public var onboardingViewModel: OnboardingViewModel {
    return container.resolve(OnboardingViewModel.self)
  }
  
  public var splashViewModel: SplashViewModel {
    return container.resolve(SplashViewModel.self)
  }
}
