//
//  UserResponse.swift
//  Hambug
//
//  Created by 차상진 on 9/30/25.
//

import Foundation

struct UserResponseData: Codable {
  let userId: Int64
  let nickname: String
  let profileImageUrl: String
  let loginType: String
  let role: String
  let isRegister: Bool
  let kakao: Bool
}
