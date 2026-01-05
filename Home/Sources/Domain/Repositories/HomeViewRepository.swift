//
//  HomeViewRepository.swift
//  HomeDomain
//
//  Created by 강동영 on 12/5/25.
//

import Foundation

public protocol HomeViewRepository {
  func fetchRecommendedBurgers() async throws -> [RecommendedBurger]
  func fetchTrendingPosts() async throws -> [TrendingPost]
}
