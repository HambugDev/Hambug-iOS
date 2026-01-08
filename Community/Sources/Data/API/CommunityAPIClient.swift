//
//  CommunityAPIClient.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import NetworkInterface

// MARK: - Community API Client Interface
public protocol CommunityAPIClientInterface {
  func fetchBoards() -> AnyPublisher<[BoardListResponse], NetworkError>
  func fetchBoardsByCategory(_ category: Category) -> AnyPublisher<[BoardResponse], NetworkError>
}

// MARK: - Community API Client Implementation
public final class CommunityAPIClient: CommunityAPIClientInterface {

  private let networkService: NetworkServiceInterface

  public init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }

  public func fetchBoards() -> AnyPublisher<[BoardListResponse], NetworkError> {
    return networkService.request(BoardEndpoint.boards, responseType: [BoardListResponse].self)
  }
  
  public func fetchBoardsByCategory(_ category: Category) -> AnyPublisher<[BoardResponse], NetworkError> {
    switch category {
    case .all, .freeTalk:
      return networkService.request(BoardEndpoint.boardsBy(category), responseType: [BoardListResponse].self)
      
    case .franchise, .handmade, .recommendation:
      return networkService.request(BoardEndpoint.boardsBy(category), responseType: [BoardFeedResponse].self)
    }
    
  }
}

// MARK: - Mock API
public final class MockCommunityAPIClient: CommunityAPIClientInterface {

  public init() {}

  public func fetchBoards() -> AnyPublisher<[BoardListResponse], NetworkError> {
    let mockData = [
      BoardListResponse(
        id: 1,
        imageURL: "https://example.com/image1.jpg",
        title: "첫 번째 게시글",
        nickName: "햄버거러버",
        content: nil,
        createdAt: Date(),
        likeCount: "15",
        commnetCount: "3"
      ),
      BoardListResponse(
        id: 2,
        imageURL: "https://example.com/image2.jpg",
        title: "맛있는 햄버거 추천",
        nickName: "음식탐험가",
        content: nil,
        createdAt: Date(),
        likeCount: "23",
        commnetCount: "7"
      )
    ]
    
    return Just(mockData)
      .setFailureType(to: NetworkError.self)
      .eraseToAnyPublisher()
  }
  
  public func fetchBoardsByCategory(_ category: Category) -> AnyPublisher<[BoardFeedResponse], NetworkError> {
    let mockData = [
      BoardFeedResponse(
        id: 1,
        imageURL: "https://example.com/image1.jpg",
        title: "첫 번째 게시글",
        nickName: "햄버거러버",
        content: "이것은 첫 번째 게시글의 상세 내용입니다.",
        createdAt: Date(),
        likeCount: "15",
        commnetCount: "3"
      )
    ]
    
    return Just(mockData)
      .setFailureType(to: NetworkError.self)
      .eraseToAnyPublisher()
  }
}
