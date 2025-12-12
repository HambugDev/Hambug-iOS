//
//  LoginEndpoint.swift
//  Hambug
//
//  Created by 강동영 on 12/5/25.
//

import Foundation

enum LoginEndpoint: Endpoint {
  var baseURL: String {
    NetworkServiceImpl.baseURL
  }
  
  case socialLogin(request: SocialLoginAuthRequestDTO)
  
  var path: String {
    switch self {
    case .socialLogin(let request):
      "/api/v1/auth/login/\(request.provider)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .socialLogin:
      return .POST
    }
  }
  
  var headers: [String : String] {
    switch self {
    default: [:]
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
    }
  }
  
}
