//
//  MyPageDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 12/13/25.
//

import DIKit
import AppDI
import NetworkInterface
import NetworkImpl
import MyPageDomain
import MyPageData
import MyPagePresentation

struct MyPageAssembly: Assembly {
  
  func assemble(container: GenericDIContainer) {
    
    container.register(MyPageRepository.self) { resolver in
      MyPageRepositoryImpl(
        networkService: resolver.resolve(NetworkServiceInterface.self)
      )
    }
    
    container.register(MyPageUseCase.self) { resolver in
      MyPageUseCaseImpl(
        repository: resolver.resolve(MyPageRepository.self)
      )
    }
    
    container.register(MyPageViewModel.self) { resolver in
      MyPageViewModel(
        usecase: resolver.resolve(MyPageUseCase.self)
      )
    }
    
  }
}

// MARK: - MyPage DI Container
public final class MyPageDIContainer {
  
  // MARK: - Properties
  private let container: GenericDIContainer
  
  // MARK: - Initialization
  public init(appContainer: AppDIContainer? = nil) {
    let parent = appContainer ?? AppDIContainer.shared
    self.container = AppDIContainer.shared.baseContainer
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
