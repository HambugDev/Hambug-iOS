//
//  LoginDTO.swift
//  Hambug
//
//  Created by 강동영 on 12/8/25.
//

import Foundation

enum SNSProviderType {
  case kakao
  case apple
  
  var identifier: String {
    switch self {
    case .kakao:
      return "kakao"
      case .apple:
      return "apple"
    }
  }
}

struct SocialLoginAuthRequestDTO {
  let provider: String
  let accessToken: String
  
  init(provider: String, accessToken: String) {
    self.provider = provider
    self.accessToken = accessToken
  }
  
  init(provider: SNSProviderType, accessToken: String) {
    self.provider = provider.identifier
    self.accessToken = accessToken
  }
}

struct UserResponse: Decodable {
  let user: UserResponseData
  let token: AuthTokenResponse
}

struct AuthTokenResponse: Decodable {
  let accessToken: String
  let refreshToken: String
}
