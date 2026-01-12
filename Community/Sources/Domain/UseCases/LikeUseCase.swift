//
//  LikeUseCase.swift
//  Hambug
//
//  Created by Claude on 01/10/26.
//

import Foundation

// MARK: - Like UseCase Protocol
public protocol LikeUseCase: Sendable {
  func getLikeInfo(boardId: Int) async throws -> LikeInfo
  func toggleLike(boardId: Int) async throws -> LikeInfo
}

// MARK: - Like UseCase Implementation
public final class LikeUseCaseImpl: LikeUseCase {

  private let repository: CommunityRepository

  public init(repository: CommunityRepository) {
    self.repository = repository
  }

  public func getLikeInfo(boardId: Int) async throws -> LikeInfo {
    return try await repository.fetchLikeInfo(boardId: boardId)
  }

  public func toggleLike(boardId: Int) async throws -> LikeInfo {
    return try await repository.toggleLike(boardId: boardId)
  }
}
