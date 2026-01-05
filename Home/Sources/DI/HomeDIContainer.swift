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
import NetworkInterface
import HomeDomain
import HomeData
import HomePresentation

import SwiftUI

// MARK: - Home Assembly
struct HomeAssembly: Assembly {
  func assemble(container: GenericDIContainer) {
    // Note: TokenStorage, UserDefaultsManager, AppStateManager come from parent

    // Repository - AppDIContainer의 NetworkService 직접 의존
    container.register(HomeViewRepository.self) { resolver in
      HomeViewRepositoryImpl(networkService: resolver.resolve(NetworkServiceInterface.self))
    }

    // Use Cases - Repository 의존
    container.register(FetchRecommendedBurgersUseCase.self) { resolver in
      FetchRecommendedBurgersUseCaseImpl(repository: resolver.resolve(HomeViewRepository.self))
    }

    container.register(FetchTrendingPostsUseCaseInterface.self) { resolver in
      FetchTrendingPostsUseCase(repository: resolver.resolve(HomeViewRepository.self))
    }

    // ViewModel - Use Cases 의존
    container.register(HomeViewModel.self) { resolver in
      HomeViewModel(
        fetchRecommendedBurgersUseCase: resolver.resolve(FetchRecommendedBurgersUseCase.self),
        fetchTrendingPostsUseCase: resolver.resolve(FetchTrendingPostsUseCaseInterface.self)
      )
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

#Preview {
  HomeView(viewModel: HomeDIContainer.init().homeViewModel)
}
