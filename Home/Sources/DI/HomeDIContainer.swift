//
//  HomeDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 12/17/25.
//

import Foundation
import DIKit
import Managers
import DataSources
import NetworkInterface
import HomeDomain
import HomeData
import HomePresentation

import CommunityPresentation
import AlarmPresentation

import SwiftUI
import CommunityDI
import AlarmDI

// MARK: - Home Assembly
struct HomeAssembly: Assembly {
  func assemble(container: GenericDIContainer) {
    // Note: TokenStorage, UserDefaultsManager, AppStateManager come from parent

    // Repository - AppDIContainer의 NetworkService 직접 의존
    container.register(HomeViewRepository.self) { resolver in
      HomeViewRepositoryImpl(networkService: resolver.resolve(NetworkServiceInterface.self))
    }

    // UseCase - Repository 의존
    container.register(HomeUseCase.self) { resolver in
      HomeUseCaseImpl(repository: resolver.resolve(HomeViewRepository.self))
    }

    // ViewModel - UseCase 의존
    container.register(HomeViewModel.self) { resolver in
      MainActor.assumeIsolated {
        HomeViewModel(homeUseCase: resolver.resolve(HomeUseCase.self))
      }
    }
  }
}

// MARK: - Home DI Container
public final class HomeDIContainer {

  // MARK: - Properties
  private let container: GenericDIContainer

  // MARK: - Initialization
  public init(appContainer: GenericDIContainer) {
    self.container = appContainer
    HomeAssembly().assemble(container: container)
  }
}

extension HomeDIContainer: Homedependency {
  public var component: any CommunityPresentation.CommunityDetailDependency {
    container.resolve(CommunityDIContainer.self)
  }
  
  public var alarmListComponent: any AlarmPresentation.AlarmListDependecy {
    container.resolve(AlarmDIContainer.self)
  }
  
  public func makeHomeViewModel() -> HomePresentation.HomeViewModel {
    container.resolve(HomeViewModel.self)
  }
}

//#Preview {
//  HomeView(viewModel: HomeDIContainer.init().homeViewModel)
//}
