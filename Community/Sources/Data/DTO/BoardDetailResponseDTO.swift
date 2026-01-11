//
//  BoardDetailResponseDTO.swift
//  Community
//
//  Created by 강동영 on 1/11/26.
//

import Foundation
import CommunityDomain

// MARK: - Board Response DTO
public struct BoardDetailResponseDTO: Decodable, Sendable {
  public let id: Int
  public let title: String
  public let content: String
  public let category: String
  public let imageUrls: [String]
  public let authorNickname: String
  public let authorProfileImageUrl: String?
  public let authorId: Int
  public let createdAt: String
  public let updatedAt: String
  public let viewCount: Int
  public let likeCount: Int
  public let commentCount: Int
  public let isLiked: Bool

  private enum CodingKeys: String, CodingKey {
    case id, title, content, category
    case imageUrls
    case authorNickname
    case authorProfileImageUrl
    case authorId
    case createdAt
    case updatedAt
    case viewCount
    case likeCount
    case commentCount
    case isLiked
  }
}

// MARK: - DTO to Domain Mapper
extension BoardDetailResponseDTO {
  func toDomain() -> Board {
    let dateFormatter = DateFormatter.iso8601WithMicroseconds
    
    return Board(
      id: id,
      title: title,
      content: content,
      category: BoardCategory(rawValue: category) ?? .freeTalk,
      imageUrls: imageUrls,
      authorNickname: authorNickname,
      authorProfileImageUrl: authorProfileImageUrl,
      authorId: authorId,
      createdAt: dateFormatter.date(from: createdAt) ?? Date(),
      updatedAt: dateFormatter.date(from: updatedAt) ?? Date(),
      viewCount: viewCount,
      likeCount: likeCount,
      commentCount: commentCount,
      isLiked: isLiked
    )
  }
}
