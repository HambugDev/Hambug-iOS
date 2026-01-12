//
//  GetMyBoardsUseCase.swift
//  MyPage
//
//  Created by Claude on 1/12/26.
//

import Foundation
import CommunityDomain

// MARK: - GetMyBoardsUseCase Protocol
public protocol GetMyBoardsUseCase: Sendable {
  func execute(lastId: Int?, limit: Int, order: String) async throws -> BoardListData
}

// MARK: - GetMyBoardsUseCase Implementation
public final class GetMyBoardsUseCaseImpl: GetMyBoardsUseCase {
  private let repository: MyPageRepository

  public init(repository: MyPageRepository) {
    self.repository = repository
  }

  public func execute(lastId: Int?, limit: Int, order: String) async throws -> BoardListData {
    return try await repository.fetchMyBoards(lastId: lastId, limit: limit, order: order)
  }
}
