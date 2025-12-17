//
//  LoginDTO.swift
//  Hambug
//
//  Created by 강동영 on 12/8/25.
//

import Foundation

// MARK: - API Request DTOs

struct SocialLoginAuthRequestDTO {
  let provider: String
  let accessToken: String

  init(provider: String, accessToken: String) {
    self.provider = provider
    self.accessToken = accessToken
  }
}

struct UserResponse: Decodable {
  let user: UserResponseData
  let token: AuthTokenResponse
}

struct UserResponseData: Codable {
  let userId: Int64
  let nickname: String
  let profileImageUrl: String
  let loginType: String
  let role: String
  let isRegister: Bool
  let kakao: Bool
}

struct AuthTokenResponse: Decodable {
  let accessToken: String
  let refreshToken: String
}
