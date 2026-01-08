//
//  HomeError.swift
//  Hambug
//
//  Created by Claude on 01/07/26.
//

import Foundation

// MARK: - Home Error
public enum HomeError: Error, LocalizedError {
  // 네트워크 관련
  case networkFailure(underlying: Error)
  case unauthorized
  case serverError(statusCode: Int)

  // 데이터 관련
  case dataCorrupted
  case emptyRecommendedBurgers
  case emptyTrendingPosts

  // 비즈니스 로직
  case invalidBurgerData(reason: String)
  case invalidPostData(reason: String)

  public var errorDescription: String? {
    switch self {
    case .networkFailure:
      return "네트워크 연결을 확인해주세요."
    case .unauthorized:
      return "로그인이 필요한 서비스입니다."
    case .serverError(let code):
      return "서버 오류가 발생했습니다. (코드: \(code))"
    case .dataCorrupted:
      return "데이터를 불러오는 중 문제가 발생했습니다."
    case .emptyRecommendedBurgers:
      return "추천 버거 정보를 불러올 수 없습니다."
    case .emptyTrendingPosts:
      return "인기 게시글을 불러올 수 없습니다."
    case .invalidBurgerData(let reason):
      return "버거 데이터 오류: \(reason)"
    case .invalidPostData(let reason):
      return "게시글 데이터 오류: \(reason)"
    }
  }

  // 에러 심각도 (UI 표시 방식 결정)
  public var severity: ErrorSeverity {
    switch self {
    case .unauthorized, .serverError:
      return .critical
    case .networkFailure, .dataCorrupted:
      return .high
    case .emptyRecommendedBurgers, .emptyTrendingPosts:
      return .medium
    case .invalidBurgerData, .invalidPostData:
      return .low
    }
  }
}

// MARK: - Error Severity
public enum ErrorSeverity {
  case critical  // Alert로 표시
  case high      // Toast로 표시
  case medium    // 인라인 메시지
  case low       // 콘솔 로그만
}
