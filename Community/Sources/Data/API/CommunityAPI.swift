//
//  CommunityAPI.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import NetworkInterface

// MARK: - Board Endpoints (Moya Style)
public enum BoardEndpoint: Endpoint {
  case boards
  case boardsBy(_ category: Category)

  public var baseURL: String {
    return "https://hambug.p-e.kr/api/v1"
  }
  
  public var path: String {
    switch self {
    case .boards, .boardsBy(_):
      return "/boards"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    default:
      return .GET
    }
  }
  
  public var headers: [String: String] {
    var headers: [String: String] = [:]
    return headers
  }
  
  public var queryParameters: [String: Any] {
    switch self {
    case .boards:
      return [:]
    case .boardsBy(let category):
      return ["category": category.rawValue]
    }
  }
  
  public var body: Data? {
    return nil
  }
}
