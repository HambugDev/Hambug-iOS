//
//  AlarmDIContainer.swift
//  Alarm
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import DIKit
import AppDI
import NetworkInterface
import AlarmDomain
import AlarmData
import AlarmPresentation

struct AlarmAssembly: Assembly {

  func assemble(container: GenericDIContainer) {
    // Repository registration
    container.register(AlarmRepository.self) { resolver in
      AlarmRepositoryImpl(
        networkService: resolver.resolve(NetworkServiceInterface.self)
      )
    }
    
    container.register(GetAlarmListUseCase.self) { resolver in
      GetAlarmListUseCaseImpl(
        repository: resolver.resolve(AlarmRepository.self)
      )
    }
    
    container.register(AlarmListViewModel.self) { resolver in
      AlarmListViewModel(
        usecase: resolver.resolve(GetAlarmListUseCase.self)
      )
    }
  }
}

// MARK: - Alarm DI Container
public final class AlarmDIContainer {

  // MARK: - Properties
  private let container: GenericDIContainer

  // MARK: - Initialization
  public init(appContainer: GenericDIContainer) {
    self.container = appContainer
    AlarmAssembly().assemble(container: container)
  }
}

extension AlarmDIContainer: AlarmListDependecy {
  public func makeAlarmListViewModel() -> AlarmListViewModel {
    return container.resolve(AlarmListViewModel.self)
  }
}
//#Preview {
//  let diContainer = CommunityDIContainer()
//  CommunityView(viewModel: diContainer.makeCommunityViewModel(), diContainer: diContainer)
//}
