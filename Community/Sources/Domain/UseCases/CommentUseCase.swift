//
//  CommentUseCase.swift
//  Hambug
//
//  Created by Claude on 01/10/26.
//

import Foundation

// MARK: - Comment UseCase Protocol
public protocol CommentUseCase: Sendable {
  func getComments(boardId: Int, lastId: Int?, limit: Int, order: SortOrder) async throws -> CommentListData
  func createComment(boardId: Int, content: String) async throws -> Comment
  func updateComment(boardId: Int, commentId: Int, content: String) async throws -> Comment
  func deleteComment(boardId: Int, commentId: Int) async throws
}

// MARK: - Comment UseCase Implementation
public final class CommentUseCaseImpl: CommentUseCase {

  private let repository: CommunityRepository

  public init(repository: CommunityRepository) {
    self.repository = repository
  }

  public func getComments(boardId: Int, lastId: Int?, limit: Int, order: SortOrder) async throws -> CommentListData {
    return try await repository.fetchComments(boardId: boardId, lastId: lastId, limit: limit, order: order)
  }

  public func createComment(boardId: Int, content: String) async throws -> Comment {
    return try await repository.createComment(boardId: boardId, content: content)
  }

  public func updateComment(boardId: Int, commentId: Int, content: String) async throws -> Comment {
    return try await repository.updateComment(boardId: boardId, commentId: commentId, content: content)
  }

  public func deleteComment(boardId: Int, commentId: Int) async throws {
    try await repository.deleteComment(boardId: boardId, commentId: commentId)
  }
}
