//
//  MyPageDTO.swift
//  MyPage
//
//  Created by 강동영 on 12/19/25.
//

import SharedDomain

// MARK: - Request DTOs
struct UpdateNicknameRequest: Codable {
  let nickname: String
}

// MARK: - Response DTOs

/// 회원 정보 조회
struct UserProfileDTO: Decodable {
  let userId: Int
  let nickname: String
  let profileImageUrl: String
  let loginType: String
  let role: String
  let isRegister: Bool?
  let kakao: Bool
}

extension UserProfileDTO {
  func toDomain() -> User {
    return User(
      userId: Int64(userId),
      nickname: nickname,
      profileImageURL: profileImageUrl,
      loginType: loginType,
      role: role,
      isRegister: isRegister,
      kakao: kakao
    )
  }
}

struct MyPostsResponse: Codable {
  let success: Bool
  let data: [MyPostItem]
  let message: String
  let code: Int
}

struct MyCommentsResponse: Codable {
  let success: Bool
  let data: [MyCommentItem]
  let message: String
  let code: Int
}

struct MyPostItem: Codable, Identifiable {
  let id: Int
  let title: String
  let content: String?
  let imageURL: String?
  let likeCount: String
  let commentCount: String
  let createdAt: String
  let category: String
}

struct MyCommentItem: Codable, Identifiable {
  let id: Int
  let content: String
  let createdAt: String
  let postId: Int
  let postTitle: String
  let likeCount: String
}
