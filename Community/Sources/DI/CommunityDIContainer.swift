//
//  CommunityDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import DIKit
import AppDI
import NetworkInterface
import NetworkImpl
import CommunityDomain
import CommunityData
import CommunityPresentation
import Managers

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
    // NetworkService registration (only for mock mode)
    // In normal mode, NetworkService comes from parent container
//    if isMock {
//      container.register(NetworkServiceInterface.self) { _ in
//        let config = URLSessionConfiguration.ephemeral
//        config.protocolClasses = [CommunityURLProtocol.self]
//        setupURLProtocol()
//        return NetworkServiceImpl(configuration: config)
//      }
//    }

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
    container.register(CommunityViewModel.self) { @MainActor resolver in
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

    container.register(CommunityDetailViewModel.self) { @MainActor resolver in
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
  public init(appContainer: AppDIContainer = .shared) {
    self.container = GenericDIContainer(parent: appContainer.baseContainer)
    CommunityAssembly().assemble(container: container)
    CommunityWriteAssembly().assemble(container: container)
  }

  // MARK: - Factory Methods
  @MainActor
  public func makeCommunityViewModel() -> CommunityViewModel {
    return container.resolve(CommunityViewModel.self)
  }
}

extension CommunityDIContainer: CommunityWriteFactory {
  public func makeWriteViewModel() -> any CommunityWriteViewModelProtocol {
    container.resolve(CommunityWriteViewModel.self)
  }
}

extension CommunityDIContainer: CommunityDetailFactory {
  @MainActor
  public func makeDetailViewModel() -> CommunityDetailViewModel {
    return container.resolve(CommunityDetailViewModel.self)
  }
}

extension CommunityDIContainer: UpdateBoardFactory {
  public func makeViewModel(boardId: Int) -> CommunityWriteViewModelProtocol {
    return UpdateBoardViewModel(
      boardId: boardId,
      updateBoardUseCase: container.resolve(UpdateBoardUseCase.self)
    )
  }
}

extension CommunityDIContainer: ReportBoardFactory {
  public func makeViewModel(req: ReportRequest) -> CommunityReportViewModel {
    return CommunityReportViewModel(
      usecase: container.resolve(ReportContentUseCase.self),
      reportInfo: req
    )
  }
}

// MARK: - Mock Setup
private func setupURLProtocol() {
  let boardsData: [[String: Any]] = [
    [
      "id": 1,
      "imageURL": "https://example.com/image1.jpg",
      "title": "첫 번째 게시글",
      "nickName": "햄버거러버",
      "createdAt": "2024-10-17T10:00:00.000Z",
      "likeCount": "15",
      "commnetCount": "3"
    ],
    [
      "id": 2,
      "imageURL": "https://example.com/image2.jpg",
      "title": "맛있는 햄버거 추천",
      "nickName": "음식탐험가",
      "createdAt": "2024-10-17T09:30:00.000Z",
      "likeCount": "23",
      "commnetCount": "7"
    ]
  ]
  
  let boardsResponse: [String: Any] = [
    "success": true,
    "data": boardsData,
    "message": "성공",
    "code": 200
  ]
  
  let boardsResponseData = try! JSONSerialization.data(withJSONObject: boardsResponse, options: [])
  
  let boardDetailResponse: [String: Any] = [
    "id": 1,
    "imageURL": "https://example.com/image1.jpg",
    "title": "첫 번째 게시글",
    "content": "이것은 첫 번째 게시글의 상세 내용입니다.",
    "nickName": "햄버거러버",
    "createdAt": "2024-10-17T10:00:00.000Z",
    "likeCount": "15",
    "commnetCount": "3"
  ]
  
  let boardDetailResponseData = try! JSONSerialization.data(withJSONObject: boardDetailResponse, options: [])
  
  CommunityURLProtocol.successMock = [
    "/api/v1/boards": (200, boardsResponseData),
    "/api/v1/boards?category=FREE_TALK": (200, boardsResponseData),
    "/api/v1/boards?category=FRANCHISE": (200, boardsResponseData),
    "/api/v1/boards?category=HANDMADE": (200, boardsResponseData),
    "/api/v1/boards?category=RECOMMENDATION": (200, boardsResponseData)
  ]
}

//#Preview {
//  let diContainer = CommunityDIContainer()
//  CommunityView(viewModel: diContainer.makeCommunityViewModel(), diContainer: diContainer)
//}
