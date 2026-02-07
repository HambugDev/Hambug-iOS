//
//  MyPageDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 12/13/25.
//

import DIKit
import NetworkInterface
import Managers
import MyPageDomain
import MyPageData
import MyPagePresentation

struct MyPageAssembly: Assembly {

  func assemble(container: GenericDIContainer) {

    // Repository (singleton)
    container.register(MyPageRepository.self) { resolver in
      MyPageRepositoryImpl(
        networkService: resolver.resolve(NetworkServiceInterface.self),
        userDefaultsManager: resolver.resolve(UserDefaultsManager.self)
      )
    }

    // Profile UseCase
    container.register(MyPageUseCase.self) { resolver in
      MyPageUseCaseImpl(
        repository: resolver.resolve(MyPageRepository.self)
      )
    }

    // Activities UseCases
    container.register(GetMyBoardsUseCase.self) { resolver in
      GetMyBoardsUseCaseImpl(
        repository: resolver.resolve(MyPageRepository.self)
      )
    }

    container.register(GetMyCommentsUseCase.self) { resolver in
      GetMyCommentsUseCaseImpl(
        repository: resolver.resolve(MyPageRepository.self)
      )
    }

    // ViewModels
    container.register(MyPageViewModel.self) { resolver in
      MyPageViewModel(
        usecase: resolver.resolve(MyPageUseCase.self)
      )
    }

    container.register(MyActivitiesViewModel.self) { resolver in
      MyActivitiesViewModel(
        getMyBoardsUseCase: resolver.resolve(GetMyBoardsUseCase.self),
        getMyCommentsUseCase: resolver.resolve(GetMyCommentsUseCase.self)
      )
    }

  }
}

// MARK: - MyPage DI Container
public final class MyPageDIContainer {
  
  // MARK: - Properties
  private let container: GenericDIContainer
  
  // MARK: - Initialization
  public init(appContainer: GenericDIContainer) {
    self.container = appContainer
    MyPageAssembly().assemble(container: container)
  }
  
  // MARK: - Factory Methods
  public func makeMyPageViewModel() -> MyPageViewModel {
    return container.resolve(MyPageViewModel.self)
  }

  public func resolve<T>(_ type: T.Type) -> T {
    return container.resolve(type)
  }
}

extension MyPageDIContainer: ActivitesFactory {
  public func makeMyActivitiesViewModel() -> MyActivitiesViewModel {
    return container.resolve(MyActivitiesViewModel.self)
  }
}
