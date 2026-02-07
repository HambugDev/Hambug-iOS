//
//  CommunityDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import DIKit
import NetworkInterface
import CommunityDomain
import CommunityData
import CommunityPresentation
import Managers
import AlarmPresentation

struct CommunityWriteAssembly: Assembly {
  func assemble(container: GenericDIContainer) {
    container.register(CreateBoardUseCase.self) { resolver in
      CreateBoardUseCaseImpl(repository: resolver.resolve(CommunityRepository.self))
    }
    
    container.register(CommunityWriteViewModel.self) { resolver in
      CommunityWriteViewModel(createBoardUseCase: resolver.resolve(CreateBoardUseCase.self))
    }
    
    container.register(UpdateBoardUseCase.self) { resolver in
      UpdateBoardUseCaseImpl(repository: resolver.resolve(CommunityRepository.self))
    }
  }
}
// MARK: - Community Assembly
struct CommunityAssembly: Assembly {

  func assemble(container: GenericDIContainer) {
    // APIClient registration
    container.register(CommunityAPIClientInterface.self) { resolver in
//      if self.isMock {
//        return MockCommunityAPIClient()
//      } else {
      return CommunityAPIClient(networkService: resolver.resolve(NetworkServiceInterface.self))
//      }
    }

    // Repository registration
    container.register(CommunityRepository.self) { resolver in
      CommunityRepositoryImpl(apiClient: resolver.resolve(CommunityAPIClientInterface.self))
    }

    // UseCase registration
    container.register(GetBoardsUseCase.self) { resolver in
      GetBoardsUseCaseImpl(repository: resolver.resolve(CommunityRepository.self))
    }

    container.register(GetBoardsByCategoryUseCase.self) { resolver in
      GetBoardsByCategoryUseCaseImpl(repository: resolver.resolve(CommunityRepository.self))
    }

    // MARK: - CommunityViewModel registration
    container.register(CommunityViewModel.self) { resolver in
      CommunityViewModel(
        getBoardsUseCase: resolver.resolve(GetBoardsUseCase.self),
        getBoardsByCategoryUseCase: resolver.resolve(GetBoardsByCategoryUseCase.self)
      )
    }

    container.register(BoardDetailUseCase.self) { resolver in
      BoardDetailUseCaseImpl(repository: resolver.resolve(CommunityRepository.self))
    }

    container.register(CommentUseCase.self) { resolver in
      CommentUseCaseImpl(repository: resolver.resolve(CommunityRepository.self))
    }

    container.register(LikeUseCase.self) { resolver in
      LikeUseCaseImpl(repository: resolver.resolve(CommunityRepository.self))
    }

    container.register(ReportContentUseCase.self) { resolver in
      ReportContentUseCaseImpl(repository: resolver.resolve(CommunityRepository.self))
    }

    container.register(CommunityDetailViewModel.self) { resolver in
      CommunityDetailViewModel(
        boardDetailUseCase: resolver.resolve(BoardDetailUseCase.self),
        commentUseCase: resolver.resolve(CommentUseCase.self),
        likeUseCase: resolver.resolve(LikeUseCase.self),
        reportContentUseCase: resolver.resolve(ReportContentUseCase.self),
        userDefaultsManager: resolver.resolve(UserDefaultsManager.self)
      )
    }
  }
}

// MARK: - Community DI Container
public final class CommunityDIContainer {

  // MARK: - Properties
  private let container: GenericDIContainer

  // MARK: - Initialization
  public init(appContainer: GenericDIContainer) {
    self.container = appContainer
    CommunityAssembly().assemble(container: container)
    CommunityWriteAssembly().assemble(container: container)
  }
}


extension CommunityDIContainer: CommunityDependency {
  public var alarmListComponent: any AlarmPresentation.AlarmListDependecy {
    container.resolve(AlarmDIContainer.self)
  }
  
  public var component: any CommunityPresentation.CommunityDetailDependency {
    self
  }
  
  // MARK: - Factory Methods
  public func makeCommunityViewModel() -> CommunityViewModel {
    return container.resolve(CommunityViewModel.self)
  }
  
  public func makeWriteViewModel() -> any CommunityPresentation.CommunityWriteViewModelProtocol {
    container.resolve(CommunityWriteViewModel.self)
  }
}

extension CommunityDIContainer: CommunityDetailDependency {
  public func makeDetailViewModel() -> CommunityPresentation.CommunityDetailViewModel {
    container.resolve(CommunityDetailViewModel.self)
  }
  
  public func makeViewModel(boardId: Int) -> any CommunityPresentation.CommunityWriteViewModelProtocol {
    UpdateBoardViewModel(
      boardId: boardId,
      boardDetailUseCase: container.resolve(BoardDetailUseCase.self),
      updateBoardUseCase: container.resolve(UpdateBoardUseCase.self)
    )
  }
  
  public func makeViewModel(req: ReportRequest) -> CommunityReportViewModel {
    return CommunityReportViewModel(
      usecase: container.resolve(ReportContentUseCase.self),
      reportInfo: req
    )
  }
}

//#Preview {
//  let diContainer = CommunityDIContainer()
//  CommunityView(viewModel: diContainer.makeCommunityViewModel(), diContainer: diContainer)
//}
