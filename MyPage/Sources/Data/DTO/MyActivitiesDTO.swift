//
//  MyActivitiesDTO.swift
//  MyPage
//
//  Created by Claude on 1/12/26.
//

import Foundation
import CommunityDomain
import MyPageDomain
import Util

// MARK: - MyBoards Response DTOs
public struct MyBoardsResponseDTO: Decodable, Sendable {
  public let content: [MyBoardItemDTO]
  public let nextCursorId: Int?
  public let nextPage: Bool
}

public struct MyBoardItemDTO: Decodable, Sendable {
  public let id: Int64
  public let title: String
  public let content: String
  public let authorNickname: String
  public let viewCount: Int64
  public let commentCount: Int64
  public let likeCount: Int64
  public let category: String
  public let imageUrls: [String]
  public let createAt: String
}

// MARK: - MyComments Response DTOs
public struct MyCommentsResponseDTO: Decodable, Sendable {
  public let content: [MyCommentItemDTO]
  public let nextCursorId: Int?
  public let nextPage: Bool
}

public struct MyCommentItemDTO: Decodable, Sendable {
  public let boardId: Int64
  public let title: String
  public let commentId: Int64
  public let content: String
  public let createdAt: String
}

// MARK: - MyBoardsResponseDTO to Domain Mapping
extension MyBoardsResponseDTO {
  func toDomain() -> BoardListData {
    return BoardListData(
      content: content.map { $0.toDomain() },
      nextCursorId: nextCursorId,
      nextPage: nextPage
    )
  }
}

extension MyBoardItemDTO {
  func toDomain() -> Board {
    let dateFormatter = DateFormatter.iso8601WithMicroseconds
    let createdDate = dateFormatter.date(from: createAt) ?? Date()

    return Board(
      id: Int(id),
      title: title,
      content: content,
      category: BoardCategory(rawValue: category) ?? .freeTalk,
      imageUrls: imageUrls,
      authorNickname: authorNickname,  // API 미제공
      authorId: nil,
      createdAt: createdDate,
      updatedAt: createdDate,
      viewCount: Int(viewCount),
      likeCount: Int(likeCount),
      commentCount: Int(commentCount),
      isLiked: false
    )
  }
}

// MARK: - MyCommentsResponseDTO to Domain Mapping
extension MyCommentsResponseDTO {
  func toDomain() -> MyCommentActivityListData {
    return MyCommentActivityListData(
      content: content.map { $0.toDomain() },
      nextCursorId: nextCursorId,
      hasNextPage: nextPage
    )
  }
}

extension MyCommentItemDTO {
  func toDomain() -> MyCommentActivity {
    let dateFormatter = DateFormatter.iso8601WithMicroseconds
    let createdDate = dateFormatter.date(from: createdAt) ?? Date()

    return MyCommentActivity(
      commentId: commentId,
      boardId: boardId,
      boardTitle: title,
      content: content,
      createdAt: createdDate
    )
  }
}
