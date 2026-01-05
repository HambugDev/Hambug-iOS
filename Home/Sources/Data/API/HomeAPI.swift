//
//  HomeAPI.swift
//  HomeData
//
//  Created by Claude on 1/5/26.
//

import Foundation
import NetworkInterface
import NetworkImpl

public enum HomeEndpoint: Endpoint {
  case recommendedBurgers
  case trendingPosts
  
  public var baseURL: String {
    return NetworkServiceImpl.baseURL
  }
  
  public var path: String {
    switch self {
    case .recommendedBurgers:
      return "/api/v1/burgers/recommended"
    case .trendingPosts:
      return "/api/v1/boards/trending"
    }
  }
  
  public var method: HTTPMethod {
    return .GET
  }
  
  public var headers: [String: String] {
    return [:]
  }
  
  public var queryParameters: [String: Any] {
    return [:]
  }
  
  public var body: Data? {
    return nil
  }
}
