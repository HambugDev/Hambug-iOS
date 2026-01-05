//
//  FetchRecommendedBurgersUseCase.swift
//  HomeDomain
//
//  Created by Claude on 1/5/26.
//

import Foundation

public final class FetchRecommendedBurgersUseCaseImpl: FetchRecommendedBurgersUseCase {
    private let repository: HomeViewRepository

    public init(repository: HomeViewRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [RecommendedBurger] {
        return try await repository.fetchRecommendedBurgers()
    }
}
