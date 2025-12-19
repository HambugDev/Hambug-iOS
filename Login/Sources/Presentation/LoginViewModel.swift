//
//  LoginViewModel.swift
//  Hambug
//
//  Created by 차상진 on 10/5/25.
//

import Foundation
import Managers
import LoginDomain
import LoginData
import NetworkInterface
import NetworkImpl
import DataSources

public final class LoginViewModel: @unchecked Sendable {
  private let useCase: LoginUseCase
  private let appStateManager: AppStateManager

  public init(useCase: LoginUseCase, appStateManager: AppStateManager) {
    self.useCase = useCase
    self.appStateManager = appStateManager
  }

  func createAppleLoginHandler() -> AppleLoginHandler {
    nonisolated(unsafe) let baseHandler = useCase.createAppleLoginHandler()

    // 기존 handler를 래핑하여 성공 시 completeLogin 호출
    return AppleLoginHandler(
      onRequest: baseHandler.onRequest,
      onCompletion: { [weak self] result in
        baseHandler.onCompletion(result)

        // 성공 시 앱 상태 전환
        if case .success = result {
          Task { @MainActor in
            self?.appStateManager.completeLogin()
          }
        }
      }
    )
  }

  func loginWithKakao() async throws {
    try await useCase.loginWithKakao()
    appStateManager.completeLogin()
  }
}



protocol Assembly {
  func assemble(container: GenericDIContainer)
}

// MARK: - Generic DIContainer Protocol
protocol DIContainer {
  func resolve<T>(_ type: T.Type) -> T
}

// MARK: - Generic DIContainer Implementation
class GenericDIContainer: DIContainer {
  private var factories: [String: Any] = [:]
  
  func register<T>(_ type: T.Type, _ factory: @escaping (GenericDIContainer) -> T) {
    let key = String(describing: type)
    factories[key] = factory
  }
  
  func resolve<T>(_ type: T.Type) -> T {
    let key = String(describing: type)
    guard let factory = factories[key] as? (GenericDIContainer) -> T else {
      fatalError("❌ \(key) is not registered")
    }
    return factory(self)
  }
}

public class ViewFactory {
  private let container: LoginDIContainer = .init()
  
  public init() {}
  @MainActor
  public func makeView() -> LoginView {
    return LoginView(viewModel: container.makeViewmodel())
  }
}
final class LoginDIContainer: GenericDIContainer {
  private let container: GenericDIContainer = LoginDIContainer()
  
  override init() {
     LoginAssembly(
      appStateManager: AppStateManager(
        tokenStorage: KeychainTokenStorage(),
        udManager: UserDefaultsManager.shared
      )
     ).assemble(container: container)
  }
  
  func makeViewmodel() -> LoginViewModel {
    return container.resolve(LoginViewModel.self)
  }
}

struct LoginAssembly: Assembly {
  private let appStateManager: AppStateManager
  private let tokenStorage: TokenStorage
  
  init(appStateManager: AppStateManager) {
    self.appStateManager = appStateManager
    self.tokenStorage = KeychainTokenStorage()
  }
  
  func assemble(container: GenericDIContainer) {
    // NetworkService registration
    container.register(NetworkServiceInterface.self) { _ in
      return NetworkServiceImpl(
        interceptor: AuthInterceptor(tokenManager: tokenStorage)
      )
    }
    
    // Repository registration
    container.register(LoginRepository.self) { resolver in
      LoginRepositoryImpl(
        networkService: resolver.resolve(NetworkServiceInterface.self),
        tokenStorage: tokenStorage
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
        appStateManager: appStateManager
      )
    }
  }
}
