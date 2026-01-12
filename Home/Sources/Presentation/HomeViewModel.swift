//
//  HomeViewModel.swift
//  HomePresentation
//
//  Created by 차상진 on 9/27/25.
//

import Foundation
import HomeDomain

@Observable
@MainActor
public final class HomeViewModel {
    // MARK: - Dependencies
    private let homeUseCase: HomeUseCase

    // MARK: - Published State
    // 데이터
    public var recommendedBurgers: [RecommendedBurger] = []
    public var trendingPosts: [TrendingPost] = []

    // 섹션별 로딩 상태
    public var isBurgersLoading: Bool = false
    public var isPostsLoading: Bool = false

    // 섹션별 에러
    public var burgersError: HomeError?
    public var postsError: HomeError?

    // MARK: - Computed Properties
    // 전체 로딩 상태
    public var isLoading: Bool {
        isBurgersLoading || isPostsLoading
    }

    // 에러 메시지 (UI 표시용)
    public var burgersErrorMessage: String? {
        burgersError?.localizedDescription
    }

    public var postsErrorMessage: String? {
        postsError?.localizedDescription
    }

    // 전체 에러 여부
    public var hasError: Bool {
        burgersError != nil || postsError != nil
    }

    // 통합 에러 메시지
    public var displayErrorMessage: String {
        if let burgersError = burgersError, postsError == nil {
            return burgersError.localizedDescription
        } else if let postsError = postsError, burgersError == nil {
            return postsError.localizedDescription
        } else if burgersError != nil && postsError != nil {
            return "일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        } else {
            return ""
        }
    }

    // MARK: - Initialization
    public init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase

        Task {
            await loadHomeData()
        }
    }

    // MARK: - Public Methods
    public func loadHomeData() async {
        // 섹션별 에러 초기화
        burgersError = nil
        postsError = nil

        // 병렬로 각각 독립적으로 로드
        async let burgersResult = loadRecommendedBurgers()
        async let postsResult = loadTrendingPosts()

        await burgersResult
        await postsResult

        // 로깅
        logHomeDataLoadStatus()
    }

    public func refresh() async {
        await loadHomeData()
    }

    // MARK: - Private Methods
    private func loadRecommendedBurgers() async {
        isBurgersLoading = true
        defer { isBurgersLoading = false }

        do {
            recommendedBurgers = try await homeUseCase.fetchRecommendedBurgers()
            print("✅ 추천 버거 \(recommendedBurgers.count)개 로드 성공")
        } catch let error as HomeError {
            burgersError = error
            print("❌ 추천 버거 로드 실패: \(error.localizedDescription)")

            // Fallback: 샘플 데이터 제공
            print("ℹ️ 추천 버거 샘플 데이터 사용")
        } catch {
            burgersError = .networkFailure(underlying: error)
            print("❌ 추천 버거 로드 실패 (알 수 없는 에러): \(error)")
        }
    }

    private func loadTrendingPosts() async {
        isPostsLoading = true
        defer { isPostsLoading = false }

        do {
            trendingPosts = try await homeUseCase.fetchTrendingPosts()
            print("✅ 트렌딩 포스트 \(trendingPosts.count)개 로드 성공")
        } catch let error as HomeError {
            postsError = error
            print("❌ 트렌딩 포스트 로드 실패: \(error.localizedDescription)")
        } catch {
            postsError = .networkFailure(underlying: error)
            print("❌ 트렌딩 포스트 로드 실패 (알 수 없는 에러): \(error)")
        }
    }

    private func logHomeDataLoadStatus() {
        if !hasError {
            print("✅ 홈 데이터 전체 로드 성공")
        } else if burgersError != nil && postsError != nil {
            print("❌ 홈 데이터 전체 로드 실패")
        } else {
            print("⚠️ 홈 데이터 부분 로드 성공")
        }
    }
}
