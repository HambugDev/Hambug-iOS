//
//  LoginDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 12/18/25.
//

import Foundation
import DIKit
import AppDI
import LoginDomain
import LoginData
import LoginPresentation
import DataSources
import Managers
import NetworkInterface

// MARK: - Login Assembly
struct LoginAssembly: Assembly {
  private let appStateManager: AppStateManager

  init(appStateManager: AppStateManager) {
    self.appStateManager = appStateManager
  }

  func assemble(container: GenericDIContainer) {
    // Note: NetworkService and TokenStorage come from parent container

    // Repository registration
    container.register(LoginRepository.self) { resolver in
      LoginRepositoryImpl(
        networkService: resolver.resolve(NetworkServiceInterface.self),
        tokenStorage: resolver.resolve(TokenStorage.self)
      )
    }

    // UseCase registration
    container.register(LoginUseCase.self) { resolver in
      LoginUseCaseImpl(
        repository: resolver.resolve(LoginRepository.self)
      )
    }

    // ViewModel registration
    container.register(LoginViewModel.self) { resolver in
      LoginViewModel(
        useCase: resolver.resolve(LoginUseCase.self),
        appStateManager: self.appStateManager
      )
    }
  }
}

// MARK: - Login DI Container
public final class LoginDIContainer {

  // MARK: - Properties
  private let container: GenericDIContainer

  // MARK: - Initialization
  public init(appContainer: AppDIContainer, appStateManager: AppStateManager) {
    self.container = GenericDIContainer(parent: appContainer.baseContainer)
    LoginAssembly(appStateManager: appStateManager).assemble(container: container)
  }

  // MARK: - Factory Methods
  public func makeLoginViewModel() -> LoginViewModel {
    return container.resolve(LoginViewModel.self)
  }

  public func resolve<T>(_ type: T.Type) -> T {
    return container.resolve(type)
  }
}
