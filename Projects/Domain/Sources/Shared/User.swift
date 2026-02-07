//
//  User.swift
//  Common
//
//  Created by 강동영 on 1/12/26.
//


public struct User {
  public let userId: Int64
  public let nickname: String
  public var profileImageURL: String
  public let loginType: String
  public let role: String
  public let isRegister: Bool?
  public let kakao: Bool

  public init(
    userId: Int64 = 0,
    nickname: String = "",
    profileImageURL: String = "",
    loginType: String = "",
    role: String = "",
    isRegister: Bool? = false,
    kakao: Bool = false
  ) {
    self.userId = userId
    self.nickname = nickname
    self.profileImageURL = profileImageURL
    self.loginType = loginType
    self.role = role
    self.isRegister = isRegister
    self.kakao = kakao
  }
}