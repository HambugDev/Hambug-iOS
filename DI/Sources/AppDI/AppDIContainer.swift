//
//  AppDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 12/18/25.
//

import Foundation
import SwiftUI
import Observation
import DIKit
import DataSources
import Managers
import NetworkInterface
import NetworkImpl

// MARK: - App Assembly
struct AppAssembly: Assembly {
  func assemble(container: GenericDIContainer) {
    // Register TokenStorage as singleton
    container.register(TokenStorage.self, scope: .singleton) { _ in
      KeychainTokenStorage()
    }

    // Register UserDefaultsManager as singleton
    container.register(UserDefaultsManager.self, scope: .singleton) { _ in
      UserDefaultsManager.shared
    }

    // Register NetworkServiceInterface as singleton
    container.register(NetworkServiceInterface.self, scope: .singleton) { resolver in
      let tokenStorage = resolver.resolve(TokenStorage.self)
      return NetworkServiceImpl(
        interceptor: AuthInterceptor(tokenManager: tokenStorage)
      )
    }

    // Register AppStateManager as singleton
    container.register(AppStateManager.self, scope: .singleton) { resolver in
      AppStateManager(
        tokenStorage: resolver.resolve(TokenStorage.self),
        udManager: resolver.resolve(UserDefaultsManager.self)
      )
    }
  }
}

// MARK: - App DI Container
@Observable
public final class AppDIContainer: @unchecked Sendable {

  // MARK: - Singleton
  public static let shared = AppDIContainer()

  // MARK: - Properties
  private let container = GenericDIContainer()

  // MARK: - Initialization
  private init() {
    AppAssembly().assemble(container: container)
  }

  // MARK: - Access Methods

  /// Get the underlying container for child containers
  public var baseContainer: GenericDIContainer {
    return container
  }

  /// Direct access to AppStateManager for app initialization
  public func makeAppStateManager() -> AppStateManager {
    return container.resolve(AppStateManager.self)
  }

  /// Generic resolve for any registered type
  public func resolve<T>(_ type: T.Type) -> T {
    return container.resolve(type)
  }
}
