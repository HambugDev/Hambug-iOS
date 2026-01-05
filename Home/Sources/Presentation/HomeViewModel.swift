//
//  HomeViewModel.swift
//  HomePresentation
//
//  Created by 차상진 on 9/27/25.
//

import Foundation
import HomeDomain

@Observable
public final class HomeViewModel {
    private let fetchRecommendedBurgersUseCase: FetchRecommendedBurgersUseCase
    private let fetchTrendingPostsUseCase: FetchTrendingPostsUseCaseInterface

    public var recommendedBurgers: [RecommendedBurger] = []
    public var trendingPosts: [TrendingPost] = []
    public var isLoading: Bool = false
    public var errorMessage: String?

    public init(
        fetchRecommendedBurgersUseCase: FetchRecommendedBurgersUseCase,
        fetchTrendingPostsUseCase: FetchTrendingPostsUseCaseInterface
    ) {
        self.fetchRecommendedBurgersUseCase = fetchRecommendedBurgersUseCase
        self.fetchTrendingPostsUseCase = fetchTrendingPostsUseCase

        Task {
            await loadHomeData()
        }
    }

    @MainActor
    public func loadHomeData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            // 병렬 API 호출
            async let burgers = try fetchRecommendedBurgersUseCase.execute()
            async let posts = try fetchTrendingPostsUseCase.execute()

            self.recommendedBurgers = try await burgers
            self.trendingPosts = try await posts
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Home API 에러: \(error)")
        }
    }

    @MainActor
    public func refresh() async {
        await loadHomeData()
    }
}
