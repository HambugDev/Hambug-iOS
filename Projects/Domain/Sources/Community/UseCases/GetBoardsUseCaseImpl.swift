//
//  GetBoardsUseCase.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation

// MARK: - Get Boards UseCase Interface
public protocol GetBoardsUseCase: Sendable {
  func execute(lastId: Int?, limit: Int, order: SortOrder) async throws -> BoardListData
}

// MARK: - Get Boards UseCase Implementation
public final class GetBoardsUseCaseImpl: GetBoardsUseCase {

  private let repository: CommunityRepository

  public init(repository: CommunityRepository) {
    self.repository = repository
  }

  public func execute(lastId: Int?, limit: Int, order: SortOrder) async throws -> BoardListData {
    return try await repository.fetchBoards(lastId: lastId, limit: limit, order: order)
  }
}
