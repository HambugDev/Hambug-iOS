//
//  FetchTrendingPostsUseCase.swift
//  HomeDomain
//
//  Created by Claude on 1/5/26.
//

import Foundation

public protocol FetchTrendingPostsUseCaseInterface {
    func execute() async throws -> [TrendingPost]
}

public final class FetchTrendingPostsUseCase: FetchTrendingPostsUseCaseInterface {
    private let repository: HomeViewRepository

    public init(repository: HomeViewRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [TrendingPost] {
        return try await repository.fetchTrendingPosts()
    }
}
