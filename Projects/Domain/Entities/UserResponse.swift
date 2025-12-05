//
//  UserResponse.swift
//  Hambug
//
//  Created by 차상진 on 9/30/25.
//

import Foundation

struct UserResponse: Codable {
    let success: Bool
    let data: UserResponseData
    let message: String
}

struct UserResponseData: Codable {
    let userId: Int64
    let email: String
    let name: String
    let nickname: String
    let profileImageUrl: String
    let loginType: String
    let role: String
    let kakao: Bool
}
