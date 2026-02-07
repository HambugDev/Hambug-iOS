//
//  ReportContentUseCase.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation

// MARK: - Report Content UseCase Interface
public protocol ReportContentUseCase: Sendable {
  func execute(request: ReportRequest) async throws
}

// MARK: - Report Content UseCase Implementation
public final class ReportContentUseCaseImpl: ReportContentUseCase {

  private let repository: CommunityRepository

  public init(repository: CommunityRepository) {
    self.repository = repository
  }

  public func execute(request: ReportRequest) async throws {
    try await repository.reportContent(request: request)
  }
}
