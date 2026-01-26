//
//  AlarmEndpoint.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import NetworkInterface

struct AlarmEndpoint: Endpoint {
  var baseURL: String = NetworkConfig.baseURL + "/api/v1"
  var path: String = "/notifications"
  var method: NetworkInterface.HTTPMethod = .GET
  var headers: [String : String] = [:]
  var queryParameters: [String : String] = [:]
  var body: Data? = nil
}
public enum BoardEndpoint: Endpoint {
  case fetchNotificaitons(CursorPagingQuery)

  public var baseURL: String {
    return NetworkConfig.baseURL + "/api/v1"
  }

  public var path: String {
    switch self {
    case .fetchNotificaitons:
      return "/notifications"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .fetchNotificaitons:
      return .GET
    }
  }

  public var headers: [String: String] {
    return [:]
  }

  public var queryParameters: [String: String] {
    switch self {
    case let .fetchNotificaitons(dto):
      return queryEncoder.encode(dto)
    default:
      return [:]
    }
  }

  public var body: Data? {
    return nil
  }
}
