//
//  HomeViewRepositoryImpl.swift
//  HomeData
//
//  Created by 차상진 on 9/27/25.
//

import Foundation
import NetworkInterface
import HomeDomain
import Util

public final class HomeViewRepositoryImpl: HomeViewRepository {
  private let networkService: NetworkServiceInterface

  public init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }

  public func fetchRecommendedBurgers() async throws -> [RecommendedBurger] {
    do {
      return try await networkService.request(
        HomeEndpoint.recommendedBurgers,
        responseType: SuccessResponse<[RecommendedBurgerResponse]>.self
      )
      .map(\.data)  // SuccessResponse 래퍼 언래핑
      .map { responses in
        responses.map { $0.toDomain() }
      }
      .async()
    } catch let error as NetworkError {
      throw mapToHomeError(error)
    } catch {
      throw HomeError.networkFailure(underlying: error)
    }
  }

  public func fetchTrendingPosts() async throws -> [TrendingPost] {
    do {
      return try await networkService.request(
        HomeEndpoint.trendingPosts,
        responseType: SuccessResponse<[TrendingPostResponse]>.self
      )
      .map(\.data)  // SuccessResponse 래퍼 언래핑
      .map { responses in
        responses.map { $0.toDomain() }
      }
      .async()
    } catch let error as NetworkError {
      throw mapToHomeError(error)
    } catch {
      throw HomeError.networkFailure(underlying: error)
    }
  }

  // MARK: - Private Methods

  private func mapToHomeError(_ networkError: NetworkError) -> HomeError {
    switch networkError {
    case .unauthorized:
      return .unauthorized
    case .serverError(let code), .serverErrorWithMessage(let code, _):
      return .serverError(statusCode: code)
    case .decodingError:
      return .dataCorrupted
    case .networkError, .noData, .invalidURL, .encodingError:
      return .networkFailure(underlying: networkError)
    case .forbidden, .notFound:
      return .serverError(statusCode: 403)
    }
  }
}
