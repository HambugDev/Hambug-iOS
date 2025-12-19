//
//  CommunityAPI.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import NetworkInterface

// MARK: - Board Endpoints (Moya Style)
enum BoardEndpoint: Endpoint {
  case boards
  case boardsBy(_ category: Category)
  
  var baseURL: String {
    return "https://hambug.p-e.kr/api/v1"
  }
  
  var path: String {
    switch self {
    case .boards, .boardsBy(_):
      return "/boards"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    default:
      return .GET
    }
  }
  
  var headers: [String: String] {
    var headers: [String: String] = [:]
    return headers
  }
  
  var queryParameters: [String: Any] {
    switch self {
    case .boards:
      return [:]
    case .boardsBy(let category):
      return ["category": category.rawValue]
    }
  }
  
  var body: Data? {
    return nil
  }
}
