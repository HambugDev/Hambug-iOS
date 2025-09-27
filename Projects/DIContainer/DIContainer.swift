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
        HomeViewUseCase(repository: homeViewRepository)
    }
    
    var homeViewModel: HomeViewModel {
        HomeViewModel(useCase: homeViewUseCase)
    }
}
