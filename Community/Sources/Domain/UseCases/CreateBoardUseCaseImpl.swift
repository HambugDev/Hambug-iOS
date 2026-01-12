//
//  CreateBoardUseCase.swift
//  Community
//
//  Created by 강동영 on 1/8/26.
//

import Foundation
import UIKit

// MARK: - Create Board UseCase Interface
public protocol CreateBoardUseCase: Sendable {
  func execute(
    title: String,
    content: String,
    category: BoardCategory,
    images: [UIImage]
  ) async throws -> Board
}

// MARK: - Create Board UseCase Implementation
public final class CreateBoardUseCaseImpl: CreateBoardUseCase {

  private let repository: CommunityRepository

  public init(repository: CommunityRepository) {
    self.repository = repository
  }

  public func execute(
    title: String,
    content: String,
    category: BoardCategory,
    images: [UIImage]
  ) async throws -> Board {
    return try await repository.createBoard(
      title: title,
      content: content,
      category: category,
      images: images
    )
  }
}
