//
//  Comment.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation

// MARK: - Comment Entity
public struct Comment: Identifiable, Equatable, Sendable {
  public let id: Int
  public let content: String
  public let authorId: Int
  public let authorNickname: String
  public let authorProfileImageUrl: String?
  public let createdAt: Date
  public let updatedAt: Date

  public init(
    id: Int,
    content: String,
    authorId: Int,
    authorNickname: String,
    authorProfileImageUrl: String?,
    createdAt: Date,
    updatedAt: Date
  ) {
    self.id = id
    self.content = content
    self.authorId = authorId
    self.authorNickname = authorNickname
    self.authorProfileImageUrl = authorProfileImageUrl
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

// MARK: - Comment List Data (Pagination)
public struct CommentListData: Sendable {
  public let content: [Comment]
  public let nextCursorId: Int?
  public let hasNextPage: Bool

  public init(content: [Comment], nextCursorId: Int?, hasNextPage: Bool) {
    self.content = content
    self.nextCursorId = nextCursorId
    self.hasNextPage = hasNextPage
  }
}
