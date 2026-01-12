//
//  LikeResponse.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation
import CommunityDomain

// MARK: - Like Response DTO
public struct LikeResponseDTO: Decodable, Sendable {
  public let boardId: Int
  public let likeCount: Int
  public let liked: Bool

  private enum CodingKeys: String, CodingKey {
    case boardId
    case likeCount
    case liked
  }
}

// MARK: - DTO to Domain Mapper
extension LikeResponseDTO {
  func toDomain() -> LikeInfo {
    return LikeInfo(
      boardId: boardId,
      likeCount: likeCount,
      isLiked: liked
    )
  }
}
