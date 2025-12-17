//
//  CommunityRepository.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import NetworkCommon

// MARK: - Community Repository Implementation
final class CommunityRepositoryImpl: CommunityRepositoryInterface {
  
  private let apiClient: CommunityAPIClientInterface
  
  init(apiClient: CommunityAPIClientInterface) {
    self.apiClient = apiClient
  }
  
  func fetchBoards() -> AnyPublisher<[Board], NetworkError> {
    return apiClient.fetchBoards()
      .map { boardResponses in
        return boardResponses.map { Board(from: $0) }
      }
      .eraseToAnyPublisher()
  }
  
  func fetchBoardsByCategory(_ category: Category) -> AnyPublisher<[Board], NetworkError> {
    return apiClient.fetchBoardsByCategory(category)
      .map { boardResponses in
        return boardResponses.map { Board(from: $0) }
      }
      .eraseToAnyPublisher()
  }
}
