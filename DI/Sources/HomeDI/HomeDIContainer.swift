//
//  HomeDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 12/17/25.
//

import Foundation
import DIKit
import AppDI
import Managers
import DataSources
import HomeDomain
import HomeData
import HomePresentation

// MARK: - Home Assembly
struct HomeAssembly: Assembly {
  func assemble(container: GenericDIContainer) {
    // Note: TokenStorage, UserDefaultsManager, AppStateManager come from parent

    // Repository registration
    container.register(HomeViewRepository.self) { _ in
      DummyHomeViewRepositoryImpl()
    }

    // UseCase registration
    container.register(HomeViewUseCase.self) { resolver in
      HomeViewUseCaseImpl(repository: resolver.resolve(HomeViewRepository.self))
    }

    // ViewModel registration
    container.register(HomeViewModel.self) { resolver in
      HomeViewModel(useCase: resolver.resolve(HomeViewUseCase.self))
    }
  }
}

// MARK: - Home DI Container
public final class HomeDIContainer {

  // MARK: - Properties
  private let container: GenericDIContainer

  // MARK: - Initialization
  public init(appContainer: AppDIContainer = .shared) {
    self.container = GenericDIContainer(parent: appContainer.baseContainer)
    HomeAssembly().assemble(container: container)
  }

  // MARK: - Factory Methods
  public var homeViewModel: HomeViewModel {
    return container.resolve(HomeViewModel.self)
  }

  public func resolve<T>(_ type: T.Type) -> T {
    return container.resolve(type)
  }
}
