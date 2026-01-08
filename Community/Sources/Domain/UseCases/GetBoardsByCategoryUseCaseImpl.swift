//
//  GetBoardsByCategoryUseCase.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation

// MARK: - Get Boards By Category UseCase Interface
public protocol GetBoardsByCategoryUseCase: Sendable {
  func execute(category: BoardCategory, lastId: Int?, limit: Int, order: SortOrder) async throws -> BoardListData
}

// MARK: - Get Boards By Category UseCase Implementation
public final class GetBoardsByCategoryUseCaseImpl: GetBoardsByCategoryUseCase {

  private let repository: CommunityRepository

  public init(repository: CommunityRepository) {
    self.repository = repository
  }

  public func execute(category: BoardCategory, lastId: Int?, limit: Int, order: SortOrder) async throws -> BoardListData {
    return try await repository.fetchBoardsByCategory(category, lastId: lastId, limit: limit, order: order)
  }
}
