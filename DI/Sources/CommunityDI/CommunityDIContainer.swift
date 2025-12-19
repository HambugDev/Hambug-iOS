//
//  CommunityDIContainer.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import DataSources
import NetworkInterface
import NetworkImpl
import DIKit
import AppDI
import CommunityDomain
import CommunityData
import CommunityPresentation

// MARK: - Community Assembly
struct CommunityAssembly: Assembly {
  private let isMock: Bool

  init(isMock: Bool = false) {
    self.isMock = isMock
  }

  func assemble(container: GenericDIContainer) {
    // NetworkService registration (only for mock mode)
    // In normal mode, NetworkService comes from parent container
    if isMock {
      container.register(NetworkServiceInterface.self) { _ in
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [CommunityURLProtocol.self]
        setupURLProtocol()
        return NetworkServiceImpl(configuration: config)
      }
    }

    // APIClient registration
    container.register(CommunityAPIClientInterface.self) { resolver in
      if self.isMock {
        return MockCommunityAPIClient()
      } else {
        return CommunityAPIClient(networkService: resolver.resolve(NetworkServiceInterface.self))
      }
    }

    // Repository registration
    container.register(CommunityRepositoryInterface.self) { resolver in
      CommunityRepositoryImpl(apiClient: resolver.resolve(CommunityAPIClientInterface.self))
    }

    // UseCase registration
    container.register(GetBoardsUseCaseInterface.self) { resolver in
      GetBoardsUseCase(repository: resolver.resolve(CommunityRepositoryInterface.self))
    }

    // ViewModel registration
    container.register(CommunityViewModel.self) { resolver in
      CommunityViewModel(getBoardsUseCase: resolver.resolve(GetBoardsUseCaseInterface.self))
    }
  }
}

// MARK: - Community DI Container
public final class CommunityDIContainer {

  // MARK: - Properties
  private let container: GenericDIContainer

  // MARK: - Initialization
  public init(appContainer: AppDIContainer? = nil, isMock: Bool = false) {
    // In mock mode: no parent (creates own NetworkService)
    // In normal mode: use AppDIContainer as parent
    if isMock {
      self.container = GenericDIContainer(parent: nil)
    } else {
      let parent = appContainer ?? AppDIContainer.shared
      self.container = GenericDIContainer(parent: parent.baseContainer)
    }

    CommunityAssembly(isMock: isMock).assemble(container: container)
  }

  // MARK: - Factory Methods
  public func makeCommunityViewModel() -> CommunityViewModel {
    return container.resolve(CommunityViewModel.self)
  }

  public func resolve<T>(_ type: T.Type) -> T {
    return container.resolve(type)
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
