//
//  UserResponse.swift
//  Hambug
//
//  Created by 강동영 on 12/16/25
//

import Foundation

/// Domain model for User
/// Separated from Data layer's UserResponseData DTO
public struct User: Codable {
  public let userId: Int64
  public let nickname: String
  public let profileImageUrl: String
  public let loginType: String
  public let role: String
  public let isRegister: Bool
  public let kakao: Bool
}
