//
//  CommentResponse.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation
import CommunityDomain
import Util

// MARK: - Comment Response DTO
public struct CommentResponseDTO: Decodable, Sendable {
  public let id: Int
  public let content: String
  public let authorId: Int
  public let authorNickname: String
  public let authorProfileImageUrl: String?
  public let createdAt: String
  public let updatedAt: String

  private enum CodingKeys: String, CodingKey {
    case id
    case content
    case authorId
    case authorNickname
    case authorProfileImageUrl
    case createdAt
    case updatedAt
  }
}

// MARK: - Comment List Data DTO (Pagination)
public struct CommentListDataDTO: Decodable, Sendable {
  public let content: [CommentResponseDTO]
  public let nextCursorId: Int?
  public let nextPage: Bool

  private enum CodingKeys: String, CodingKey {
    case content
    case nextCursorId
    case nextPage
  }
}

// MARK: - DTO to Domain Mapper
extension CommentResponseDTO {
  func toDomain() -> Comment {
    let dateFormatter = DateFormatter.iso8601WithMicroseconds

    return Comment(
      id: id,
      content: content,
      authorId: authorId,
      authorNickname: authorNickname,
      authorProfileImageUrl: authorProfileImageUrl,
      createdAt: dateFormatter.date(from: createdAt) ?? Date(),
      updatedAt: dateFormatter.date(from: updatedAt) ?? Date()
    )
  }
}

extension CommentListDataDTO {
  func toDomain() -> CommentListData {
    return CommentListData(
      content: content.map { $0.toDomain() },
      nextCursorId: nextCursorId,
      hasNextPage: nextPage
    )
  }
}
