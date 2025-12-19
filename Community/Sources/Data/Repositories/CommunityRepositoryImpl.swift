//
//  CommunityRepository.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import NetworkCommon
import CommunityDomain

// MARK: - Community Repository Implementation
public final class CommunityRepositoryImpl: CommunityRepositoryInterface {

  private let apiClient: CommunityAPIClientInterface

  public init(apiClient: CommunityAPIClientInterface) {
    self.apiClient = apiClient
  }

  public func fetchBoards() -> AnyPublisher<[Board], NetworkError> {
    return apiClient.fetchBoards()
      .map { boardResponses in
        return boardResponses.map { $0.toDomain() }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchBoardsByCategory(_ category: Category) -> AnyPublisher<[Board], NetworkError> {
    return apiClient.fetchBoardsByCategory(category)
      .map { boardResponses in
        return boardResponses.map { $0.toDomain() }
      }
      .eraseToAnyPublisher()
  }
}
