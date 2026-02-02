//
//  HomeUseCase.swift
//  HomeDomain
//
//  Created by 강동영 on 01/07/26.
//

import Foundation

// MARK: - Home UseCase Interface
public protocol HomeUseCase: Sendable {
    /// 추천 버거 목록을 가져옵니다.
    /// - Returns: 검증된 추천 버거 배열
    /// - Throws: HomeError (빈 데이터, 유효하지 않은 데이터 등)
    func fetchRecommendedBurgers() async throws -> [RecommendedBurger]

    /// 트렌딩 포스트 목록을 가져옵니다.
    /// - Returns: 검증 및 정렬된 트렌딩 포스트 배열
    /// - Throws: HomeError (빈 데이터, 유효하지 않은 데이터 등)
    func fetchTrendingPosts() async throws -> [TrendingPost]
}

// MARK: - Home UseCase Implementation
public final class HomeUseCaseImpl: HomeUseCase {
    private let repository: HomeViewRepository

    public init(repository: HomeViewRepository) {
        self.repository = repository
    }

    // MARK: - Fetch Recommended Burgers
    public func fetchRecommendedBurgers() async throws -> [RecommendedBurger] {
        // 1. Repository 호출
        let burgers = try await repository.fetchRecommendedBurgers()

        // 2. 비즈니스 로직: 데이터 검증
        guard !burgers.isEmpty else {
            throw HomeError.emptyRecommendedBurgers
        }

        // 3. 비즈니스 로직: 유효성 검증
        let validBurgers = burgers.filter { burger in
            !burger.menuName.isEmpty && !burger.franchise.isEmpty
        }

        if validBurgers.isEmpty {
            throw HomeError.invalidBurgerData(reason: "유효한 버거 정보가 없습니다")
        }

        // 4. 비즈니스 로직: 정렬 (서버 순서 유지)
        return validBurgers
    }

    // MARK: - Fetch Trending Posts
    public func fetchTrendingPosts() async throws -> [TrendingPost] {
        // 1. Repository 호출
        let posts = try await repository.fetchTrendingPosts()

        // 2. 비즈니스 로직: 데이터 검증
        guard !posts.isEmpty else {
            throw HomeError.emptyTrendingPosts
        }

        // 3. 비즈니스 로직: 유효성 검증
        let validPosts = posts.filter { post in
            !post.title.isEmpty && !post.content.isEmpty
        }

        if validPosts.isEmpty {
            throw HomeError.invalidPostData(reason: "유효한 게시글이 없습니다")
        }

        // 4. 비즈니스 로직: 최신순 정렬
        return validPosts.sorted { $0.createdAt > $1.createdAt }
    }
}
