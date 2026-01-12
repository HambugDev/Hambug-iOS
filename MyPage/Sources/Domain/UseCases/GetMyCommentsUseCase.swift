//
//  GetMyCommentsUseCase.swift
//  MyPage
//
//  Created by Claude on 1/12/26.
//

import Foundation

// MARK: - GetMyCommentsUseCase Protocol
public protocol GetMyCommentsUseCase: Sendable {
  func execute(lastId: Int?, limit: Int, order: String) async throws -> MyCommentActivityListData
}

// MARK: - GetMyCommentsUseCase Implementation
public final class GetMyCommentsUseCaseImpl: GetMyCommentsUseCase {
  private let repository: MyPageRepository

  public init(repository: MyPageRepository) {
    self.repository = repository
  }

  public func execute(lastId: Int?, limit: Int, order: String) async throws -> MyCommentActivityListData {
    return try await repository.fetchMyComments(lastId: lastId, limit: limit, order: order)
  }
}
