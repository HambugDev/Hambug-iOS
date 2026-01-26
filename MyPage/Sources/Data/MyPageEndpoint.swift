//
//  MyPageEndpoint.swift
//  MyPage
//
//  Created by 강동영 on 12/19/25.
//

import Foundation
import NetworkInterface
import NetworkImpl

// MARK: - MyPage Endpoints
enum MyPageEndpoint: Endpoint {
  case authMe
  case updateProfile(userId: Int)
  case updateNickname(userID: Int, nickname: String)
  case logout
  case deleteAccount(provider: String)
  
  case getMyBoards(query: CursorPagingQuery)
  case getMyComments(query: CursorPagingQuery)
  
  var baseURL: String {
    NetworkConfig.baseURL
  }
  
  var path: String {
    switch self {
    case .authMe:
      return "/api/v1/auth/me"
    case let .updateProfile(userId):
      return "/api/v1/users/\(userId)/profile"
    case let .updateNickname(id, _):
      return "/api/v1/users/\(id)/nickname"
    case .logout:
      return "/api/v1/auth/logout"
    case let .deleteAccount(provider):
      return "/api/v1/auth/unlink/\(provider)"
      
    case .getMyBoards:
      return "/api/v1/my-pages/boards"
    case .getMyComments:
      return "/api/v1/my-pages/comments"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .authMe, .getMyBoards, .getMyComments:
      return .GET
    case .updateProfile, .updateNickname:
      return .PUT
    case .logout, .deleteAccount:
      return .POST
    }
  }
  
  var headers: [String: String] {
    var headers: [String: String] = [:]
    return headers
  }
  
  var queryParameters: [String: String] {
    switch self {
    case let .getMyBoards(dto), let .getMyComments(dto):
      return queryEncoder.encode(dto)
    default:
      return [:]
    }
  }
  
  var body: Data? {
    switch self {
    case let .updateNickname(_, nickname):
      let request = UpdateNicknameRequest(nickname: nickname)
      return try? JSONEncoder().encode(request)
    default:
      return nil
    }
  }
}
