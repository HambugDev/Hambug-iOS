//
//  SocialLoginRequest.swift
//  Hambug
//
//  Created by Claude on 12/16/25.
//

import Foundation

/// Domain model for social login request
/// This is the pure business logic representation, independent of API DTOs
public struct SocialLoginRequest {
  public let provider: SNSProviderType
  public let accessToken: String

  public init(provider: SNSProviderType, accessToken: String) {
    self.provider = provider
    self.accessToken = accessToken
  }
}
