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
  case updateProfile(UpdateProfileRequest)
  case updateNickname(userID: Int, nickname: String)
  case logout
  case deleteAccount(provider: String)
  
  var baseURL: String {
    NetworkConfig.baseURL
  }
  
  var path: String {
    switch self {
    case .authMe:
      return "/api/v1/auth/me"
    case let .updateProfile(param):
      return "/api/v1/users/\(param.userId)/profile"
    case let .updateNickname(id, _):
      return "/api/v1/users/\(id)/nickname"
    case .logout:
      return "/api/v1/auth/logout"
    case let .deleteAccount(provider):
      return "/api/v1/auth/unlink/\(provider)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .authMe:
      return .GET
    case .updateProfile, .updateNickname:
      return .PUT
    case .logout, .deleteAccount:
      return .POST
    }
  }
  
  var headers: [String: String] {
    var headers: [String: String] = [:]
    // TODO: Add Authorization header when auth is implemented
    // headers["Authorization"] = "Bearer \(token)"
    return headers
  }
  
  var queryParameters: [String: Any] {
    switch self {
    default:
      return [:]
    }
  }
  
  var body: Data? {
    switch self {
    case .updateProfile(let request):
      // TODO: multi-part
      return try? JSONEncoder().encode(request.profileImageURL)
    case let .updateNickname(_, nickname):
      let request = UpdateNicknameRequest(nickname: nickname)
      return try? JSONEncoder().encode(request)
    default:
      return nil
    }
  }
}
