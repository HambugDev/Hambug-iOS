//
//  UpdateBoardUseCaseImpl.swift
//  Community
//
//  Created by 강동영 on 1/11/26.
//

import Foundation
import UIKit

// MARK: - Create Board UseCase Interface
public protocol UpdateBoardUseCase: Sendable {
  func execute(
    boardId: Int,
    title: String,
    content: String,
    category: BoardCategory,
    images: [UIImage]
  ) async throws -> Board
}

// MARK: - Create Board UseCase Implementation
public final class UpdateBoardUseCaseImpl: UpdateBoardUseCase {

  private let repository: CommunityRepository

  public init(repository: CommunityRepository) {
    self.repository = repository
  }

  public func execute(
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
}
