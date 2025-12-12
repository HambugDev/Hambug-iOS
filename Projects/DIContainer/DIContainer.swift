//
//  DIContainer.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import Foundation
import DataSources
import Managers


final class DIContainer {
  static let shared = DIContainer()
  
  // TokenStorage 싱글톤
  private let tokenStorage: TokenStorage
  private var udManager: UserDefaultsManager
  
  init() {
    self.tokenStorage = KeychainTokenStorage()
    self.udManager = UserDefaultsManager.shared
  }
  
  var homeViewRepository: HomeViewRepository {
    DummyHomeViewRepositoryImpl()
  }
  
  var homeViewUseCase: HomeViewUseCase {
    HomeViewUseCaseImpl(repository: homeViewRepository)
  }
  
  var homeViewModel: HomeViewModel {
    HomeViewModel(useCase: homeViewUseCase)
  }
  
  var loginRepository: LoginRepository {
    LoginRepositoryImpl(
      networkService: NetworkServiceImpl(),
      tokenStorage: tokenStorage
    )
  }
  
  var loginUseCase: LoginUseCase {
    LoginUseCaseImpl(repository: loginRepository)
  }
  
  func loginViewModel(appStateManager: AppStateManager) -> LoginViewModel {
    LoginViewModel(
      useCase: loginUseCase,
      appStateManager: appStateManager
    )
  }
  
  // AppStateManager 팩토리
  func makeAppStateManager() -> AppStateManager {
    AppStateManager(
      tokenStorage: tokenStorage,
      udManager: udManager
    )
  }
}
