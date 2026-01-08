//
//  GetBoardsUseCase.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import NetworkInterface

// MARK: - Get Boards UseCase Interface
public protocol GetBoardsUseCaseInterface {
  func execute() -> AnyPublisher<[Board], NetworkError>
}

// MARK: - Get Boards UseCase Implementation
public final class GetBoardsUseCase: GetBoardsUseCaseInterface {

  private let repository: CommunityRepositoryInterface

  public init(repository: CommunityRepositoryInterface) {
    self.repository = repository
  }

  public func execute() -> AnyPublisher<[Board], NetworkError> {
    return repository.fetchBoards()
      .map { boards in
        // 비즈니스 로직 적용 (예: 정렬, 필터링 등)
        return boards.sorted { $0.createdAt > $1.createdAt }
      }
      .eraseToAnyPublisher()
  }
}
