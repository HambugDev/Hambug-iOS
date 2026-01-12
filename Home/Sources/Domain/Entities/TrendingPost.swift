//
//  TrendingPost.swift
//  HomeDomain
//
//  Created by 강동영 on 1/5/26.
//

import Foundation
import CommunityDomain

public struct TrendingPost: Identifiable, Equatable, Sendable {
  public let id: Int
  public let title: String
  public let content: String
  public let category: BoardCategory
  public let imageUrls: [String]
  public let authorNickname: String
  public let authorId: Int
  public let createdAt: Date
  public let updatedAt: Date
  public let viewCount: Int
  public let likeCount: Int
  public let commentCount: Int
  public let isLiked: Bool
  
  // UI 표시용 계산 프로퍼티
  public var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM.dd"
    return formatter.string(from: createdAt)
  }
  
  public var formattedTime: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: createdAt)
  }
  
  public init(
    id: Int,
    title: String,
    content: String,
    category: BoardCategory,
    imageUrls: [String],
    authorNickname: String,
    authorId: Int,
    createdAt: Date,
    updatedAt: Date,
    viewCount: Int,
    likeCount: Int, commentCount: Int, isLiked: Bool) {
      self.id = id
      self.title = title
      self.content = content
      self.category = category
      self.imageUrls = imageUrls
      self.authorNickname = authorNickname
      self.authorId = authorId
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.viewCount = viewCount
      self.likeCount = likeCount
      self.commentCount = commentCount
      self.isLiked = isLiked
    }
}

// MARK: - Sample Data
extension TrendingPost {
  public static var sampleData: [TrendingPost] {
    let now = Date()
    return [
      TrendingPost(
        id: 1,
        title: "맥도날드 신메뉴 후기",
        content: "새로 나온 버거가 진짜 맛있어요!",
        category: .review,
        imageUrls: ["https://via.placeholder.com/400x300"],
        authorNickname: "햄버거러버",
        authorId: 101,
        createdAt: now.addingTimeInterval(-3600),
        updatedAt: now.addingTimeInterval(-3600),
        viewCount: 152,
        likeCount: 24,
        commentCount: 8,
        isLiked: false
      ),
      TrendingPost(
        id: 2,
        title: "버거킹 할인 정보",
        content: "이번 주 버거킹 2+1 행사!",
        category: .freeTalk,
        imageUrls: ["https://via.placeholder.com/400x300"],
        authorNickname: "버거헌터",
        authorId: 102,
        createdAt: now.addingTimeInterval(-7200),
        updatedAt: now.addingTimeInterval(-7200),
        viewCount: 98,
        likeCount: 15,
        commentCount: 5,
        isLiked: false
      ),
      TrendingPost(
        id: 3,
        title: "수제버거 맛집 추천",
        content: "홍대 근처 숨은 맛집 발견했어요",
        category: .recommendation,
        imageUrls: ["https://via.placeholder.com/400x300"],
        authorNickname: "맛집탐험가",
        authorId: 103,
        createdAt: now.addingTimeInterval(-10800),
        updatedAt: now.addingTimeInterval(-10800),
        viewCount: 234,
        likeCount: 42,
        commentCount: 12,
        isLiked: true
      )
    ]
  }
}
