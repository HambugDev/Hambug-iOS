//
//  NetworkError.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
  case invalidURL
  case noData
  case encodingError(Error)
  case decodingError(Error)
  case networkError(Error)
  case serverError(Int)
  case serverErrorWithMessage(Int, String)
  case unauthorized
  case forbidden
  case notFound
  
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "잘못된 URL입니다."
    case .noData:
      return "데이터가 없습니다."
    case .encodingError(let error):
      return "인코딩 오류: \(error.localizedDescription)"
    case .decodingError(let error):
      return "데이터 파싱 오류: \(error.localizedDescription)"
    case .networkError(let error):
      return "네트워크 오류: \(error.localizedDescription)"
    case .serverError(let code):
      return "서버 오류: \(code)"
    case .serverErrorWithMessage(let code, let message):
      return "서버 오류 (\(code)): \(message)"
    case .unauthorized:
      return "인증이 필요합니다."
    case .forbidden:
      return "접근이 금지되었습니다."
    case .notFound:
      return "요청한 리소스를 찾을 수 없습니다."
    }
  }
}
