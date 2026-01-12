//
//  MyCommentActivity.swift
//  MyPage
//
//  Created by Claude on 1/12/26.
//

import Foundation

// MARK: - MyCommentActivity Entity
public struct MyCommentActivity: Identifiable, Equatable, Sendable {
  public let id: Int64  // commentId
  public let boardId: Int64
  public let boardTitle: String
  public let content: String
  public let createdAt: String

  public init(
    commentId: Int64,
    boardId: Int64,
    boardTitle: String,
    content: String,
    createdAt: Date
  ) {
    self.id = commentId
    self.boardId = boardId
    self.boardTitle = boardTitle
    self.content = content
    self.createdAt = Self.timeAgoDisplay(createdAt)
  }

  private static func timeAgoDisplay(_ date: Date) -> String {
    let now = Date()
    let timeInterval = now.timeIntervalSince(date)

    if timeInterval < 60 {
      return "방금 전"
    } else if timeInterval < 3600 {
      let minutes = Int(timeInterval / 60)
      return "\(minutes)분 전"
    } else if timeInterval < 86400 {
      let hours = Int(timeInterval / 3600)
      return "\(hours)시간 전"
    } else if timeInterval < 604800 {
      let days = Int(timeInterval / 86400)
      return "\(days)일 전"
    } else {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd"
      return formatter.string(from: date)
    }
  }
}

// MARK: - MyCommentActivity List Data (Pagination)
public struct MyCommentActivityListData: Sendable {
  public let content: [MyCommentActivity]
  public let nextCursorId: Int?
  public let hasNextPage: Bool

  public init(content: [MyCommentActivity], nextCursorId: Int?, hasNextPage: Bool) {
    self.content = content
    self.nextCursorId = nextCursorId
    self.hasNextPage = hasNextPage
  }
}
