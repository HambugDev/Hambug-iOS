//
//  CommunityRepository.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import CommunityDomain
import NetworkInterface
import Util
import UIKit

// MARK: - Community Repository Implementation
public final class CommunityRepositoryImpl: CommunityRepository {

  private let apiClient: CommunityAPIClientInterface

  public init(apiClient: CommunityAPIClientInterface) {
    self.apiClient = apiClient
  }

  public func fetchBoards(lastId: Int?, limit: Int, order: CommunityDomain.SortOrder) async throws -> BoardListData {
    return try await apiClient
      .fetchBoards(lastId: lastId, limit: limit, order: order.rawValue)
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }

  public func fetchBoardsByCategory(_ category: BoardCategory, lastId: Int?, limit: Int, order: CommunityDomain.SortOrder) async throws -> BoardListData {
    return try await apiClient
      .fetchBoardsByCategory(category: category.rawValue, lastId: lastId, limit: limit, order: order.rawValue)
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }

  // MARK: - Board CRUD
  public func createBoard(
    title: String,
    content: String,
    category: BoardCategory,
    images: [UIImage]
  ) async throws -> Board {
    return try await apiClient
      .createBoard(
        title: title,
        content: content,
        category: category.rawValue,
        images: images
      )
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }

  public func fetchBoardDetail(boardId: Int) async throws -> Board {
    return try await apiClient
      .fetchBoardDetail(boardId: boardId)
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }
  
  public func updateBoard(
    boardId: Int,
    title: String,
    content: String,
    category: CommunityDomain.BoardCategory,
    images: [UIImage]
  ) async throws -> CommunityDomain.Board {
    return try await apiClient
      .updateBoard(
        boardId: boardId,
        title: title,
        content: content,
        category: category.rawValue,
        images: images
      )
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }
  
  public func deleteBoard(boardId: Int) async throws {
    return try await apiClient
      .deleteBoard(boardId: boardId)
      .mapError { $0 as Error }
      .async()
  }
  
  // MARK: - Comments
  public func fetchComments(boardId: Int, lastId: Int?, limit: Int, order: CommunityDomain.SortOrder) async throws -> CommentListData {
    return try await apiClient
      .fetchComments(boardId: boardId, lastId: lastId, limit: limit, order: order.rawValue)
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }

  public func createComment(boardId: Int, content: String) async throws -> Comment {
    return try await apiClient
      .createComment(boardId: boardId, content: content)
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }

  public func updateComment(boardId: Int, commentId: Int, content: String) async throws -> Comment {
    return try await apiClient
      .updateComment(boardId: boardId, commentId: commentId, content: content)
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }

  public func deleteComment(boardId: Int, commentId: Int) async throws {
    return try await apiClient
      .deleteComment(boardId: boardId, commentId: commentId)
      .mapError { $0 as Error }
      .async()
  }

  // MARK: - Likes
  public func fetchLikeInfo(boardId: Int) async throws -> LikeInfo {
    return try await apiClient
      .fetchLikeInfo(boardId: boardId)
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }

  public func toggleLike(boardId: Int) async throws -> LikeInfo {
    return try await apiClient
      .toggleLike(boardId: boardId)
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .async()
  }

  // MARK: - Report
  public func reportContent(request: CommunityDomain.ReportRequest) async throws {
    let dto = ReportRequestDTO(from: request)
    return try await apiClient
      .reportContent(request: dto)
      .mapError { $0 as Error }
      .async()
  }
}
