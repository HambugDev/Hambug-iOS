//
//  HomeViewRepositoryImpl.swift
//  HomeData
//
//  Created by 차상진 on 9/27/25.
//

import Foundation
import Combine
import NetworkCommon
import NetworkInterface
import NetworkImpl
import HomeDomain

public final class HomeViewRepositoryImpl: HomeViewRepository {
  private let networkService: NetworkServiceInterface
  
  public init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }
  
  public func fetchRecommendedBurgers() async throws -> [RecommendedBurger] {
    return try await networkService.request(
      HomeEndpoint.recommendedBurgers,
      responseType: SuccessResponse<[RecommendedBurgerResponse]>.self
    )
    .map(\.data)  // SuccessResponse 래퍼 언래핑
    .map { responses in
      responses.map { $0.toDomain() }
    }
    .async()
  }
  
  public func fetchTrendingPosts() async throws -> [TrendingPost] {
    return try await networkService.request(
      HomeEndpoint.trendingPosts,
      responseType: SuccessResponse<[TrendingPostResponse]>.self
    )
    .map(\.data)  // SuccessResponse 래퍼 언래핑
    .map { responses in
      responses.map { $0.toDomain() }
    }
    .async()
  }
}

// 테스트용 Dummy Repository (필요 시 사용)
public final class DummyHomeViewRepositoryImpl: HomeViewRepository {
  
  public init() {}
  
  public func fetchRecommendedBurgers() async throws -> [RecommendedBurger] {
    let dummyBurgers = [
      RecommendedBurger(
        id: 1,
        menuImage: "https://via.placeholder.com/150",
        franchise: "맥도날드",
        menuName: "빅맥",
        menuDescription: "두 장의 순쇠고기 패티가 들어간 클래식 버거"
      ),
      RecommendedBurger(
        id: 2,
        menuImage: "https://via.placeholder.com/150",
        franchise: "버거킹",
        menuName: "와퍼",
        menuDescription: "불꽃에 직화 구운 패티의 풍미"
      )
    ]
    
    return try await Just(dummyBurgers)
      .setFailureType(to: NetworkError.self)
      .async()
  }
  
  public func fetchTrendingPosts() async throws -> [TrendingPost] {
    let dummyPosts = [
      TrendingPost(
        id: 1,
        title: "인기 게시글 1",
        content: "내용입니다.",
        category: "FREE_TALK",
        imageUrls: [],
        authorNickname: "테스트유저",
        authorId: 1,
        createdAt: Date(),
        updatedAt: Date(),
        viewCount: 100,
        likeCount: 10,
        commentCount: 5,
        isLiked: false
      )
    ]
    
    return try await Just(dummyPosts)
      .setFailureType(to: NetworkError.self)
      .async()
  }
}
