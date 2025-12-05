//
//  DIContainer.swift
//  Hambug
//
//  Created by 차상진 on 9/27/25.
//

import Foundation


final class DIContainer {
    static let shared = DIContainer()
    
    init() {}
    
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
      LoginRepositoryImpl(networkService: NetworkServiceImpl())
    }
    
    var loginUseCase: LoginUseCase {
        LoginUseCaseImpl(repository: loginRepository)
    }
    
    var loginViewModel: LoginViewModel {
        LoginViewModel(useCase: loginUseCase)
    }
}
