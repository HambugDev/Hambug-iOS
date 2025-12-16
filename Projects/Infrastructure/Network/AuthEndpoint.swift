//
//  LoginEndpoint.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//

import Foundation

struct TokenInfo: Encodable {
  let accessToken: String
  let refreshToken: String
}

struct TokenResponse: Decodable {
  let accessToken: String
}

enum AuthEndpoint: Endpoint {
  var baseURL: String {
    NetworkServiceImpl.baseURL
  }
  
  case refresh(info: TokenInfo)
  case socialLogin(request: SocialLoginAuthRequestDTO)
  
  var path: String {
    switch self {
    case .refresh:
      "/api/v1/auth/refresh"
    case .socialLogin(let request):
      "/api/v1/auth/login/\(request.provider)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .refresh, .socialLogin:
      return .POST
    }
  }
  
  var headers: [String : String] {
    switch self {
    case .refresh(let tokenInfo):
      var dict = [String : String]()
      dict["Authorization"] = "Bearer \(tokenInfo.accessToken)"
      dict["RefreshToken"] = "\(tokenInfo.refreshToken)"
      return dict
    default: return [:]
    }
  }
  
  var queryParameters: [String : Any] {
    switch self {
    default: [:]
    }
  }
  
  var body: Data? {
    switch self {
    case .socialLogin(let request):
      let dict = ["accessToken" : "\(request.accessToken)"]
      return try? JSONEncoder().encode(dict)
    default: return nil
    }
  }
  
  
}
