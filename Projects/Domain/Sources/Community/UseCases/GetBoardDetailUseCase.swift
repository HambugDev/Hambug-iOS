//
//  GetBoardDetailUseCase.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation
import UIKit

// MARK: - Get Board Detail UseCase Interface
public protocol BoardDetailUseCase: Sendable {
  func getBoard(boardId: Int) async throws -> Board
  
  func updateBoard(
    boardId: Int,
    title: String,
    content: String,
    category: BoardCategory,
    images: [UIImage]
  ) async throws -> Board
  
  func deleteBoard(boardId: Int) async throws
}
public final class BoardDetailUseCaseImpl: BoardDetailUseCase {
  
  private let repository: CommunityRepository

  public init(repository: CommunityRepository) {
    self.repository = repository
  }
  
  public func getBoard(boardId: Int) async throws -> Board {
    return try await repository.fetchBoardDetail(boardId: boardId)
  }
  
  public func updateBoard(
    boardId: Int,
    title: String,
    content: String,
    category: BoardCategory,
    images: [UIImage]
  ) async throws -> Board {
    return try await repository.updateBoard(
      boardId: boardId,
      title: title,
      content: content,
      category: category,
      images: images
    )
  }
  
  public func deleteBoard(boardId: Int) async throws {
    return try await repository.deleteBoard(boardId: boardId)
  }
}
