//
//  Board.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation

// MARK: - Board Category
public enum BoardCategory: String, Codable, Sendable, CaseIterable {
  case freeTalk = "FREE_TALK"
  case franchise = "FRANCHISE"
  case handmade = "HANDMADE"
  case review = "REVIEW"
  case recommendation = "RECOMMENDATION"

  public var displayName: String {
    switch self {
    case .freeTalk:
      return "자유잡담"
    case .franchise:
      return "프랜차이즈"
    case .handmade:
      return "수제버거"
    case .review:
      return "햄버거리뷰"
    case .recommendation:
      return "맛집추천"
    }
  }
}

// MARK: - Sort Order
public enum SortOrder: String, Sendable {
  case asc = "ASC"
  case desc = "DESC"
}

// MARK: - Board Entity
public struct Board: Identifiable, Equatable, Sendable {
  public let id: Int
  public let title: String
  public let content: String
  public let category: BoardCategory
  public let imageUrls: [String]
  public let authorNickname: String
  public let authorProfileImageUrl: String?
  public let authorId: Int
  public let createdAt: String
  public let updatedAt: String
  public let viewCount: Int
  public let likeCount: Int
  public var commentCount: Int
  public let isLiked: Bool

  public init(
    id: Int,
    title: String,
    content: String,
    category: BoardCategory,
    imageUrls: [String],
    authorNickname: String,
    authorProfileImageUrl: String?,
    authorId: Int,
    createdAt: Date,
    updatedAt: Date,
    viewCount: Int,
    likeCount: Int,
    commentCount: Int,
    isLiked: Bool
  ) {
    self.id = id
    self.title = title
    self.content = content
    self.category = category
    self.imageUrls = imageUrls
    self.authorNickname = authorNickname
    self.authorProfileImageUrl = authorProfileImageUrl
    self.authorId = authorId
    self.createdAt = Self.timeAgoDisplay(createdAt)
    self.updatedAt = Self.timeAgoDisplay(updatedAt)
    self.viewCount = viewCount
    self.likeCount = likeCount
    self.commentCount = commentCount
    self.isLiked = isLiked
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

extension Board {
  // Preview용 샘플 데이터
  public static var sampleData: [Board] {
    let now = Date()
    return [Board(
      id: 1,
      title: "다들 햄최몇인가요12345678910121231314?",
      content: "요즘 햄버거 맛집이 어디인지 궁금해요!",
      category: .freeTalk,
      imageUrls: [],
      authorNickname: "닉네임1",
      authorProfileImageUrl: nil,
      authorId: 1,
      createdAt: now.addingTimeInterval(-60),
      updatedAt: now.addingTimeInterval(-60),
      viewCount: 100,
      likeCount: 11,
      commentCount: 10,
      isLiked: false
    )] + _sampleData
  }

  private static let _sampleData: [Board] = (2...18).map {
    let now = Date()
    return Board(
      id: $0,
      title: "다들 햄최몇인가요?",
      content: "간단한 내용입니다.",
      category: .freeTalk,
      imageUrls: [],
      authorNickname: "닉네임\($0)",
      authorProfileImageUrl: nil,
      authorId: $0,
      createdAt: now.addingTimeInterval(-120),
      updatedAt: now.addingTimeInterval(-120),
      viewCount: $0 * 10,
      likeCount: $0,
      commentCount: $0 + 1,
      isLiked: false
    )
  }
}

// MARK: - Board List Data (Pagination)
public struct BoardListData: Sendable {
  public let content: [Board]
  public let nextCursorId: Int?
  public let hasNextPage: Bool

  public init(content: [Board], nextCursorId: Int?, hasNextPage: Bool) {
    self.content = content
    self.nextCursorId = nextCursorId
    self.hasNextPage = hasNextPage
  }
}
