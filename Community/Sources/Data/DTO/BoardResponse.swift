//
//  BoardResponse.swift
//  Hambug
//
//  Created by 강동영 on 10/27/25.
//

import Foundation
import CommunityDomain

// MARK: - Unified Board Response Model
public struct BoardResponse: Decodable {
  public let id: Int
  public let imageURL: String
  public let title: String
  public let nickName: String
  public let content: String?    // 목록 조회시 nil, 카테고리에 따라 조회시 값
  public let createdAt: Date
  public let likeCount: String
  public let commnetCount: String
}

extension BoardResponse {
  func toDomain() -> Board {
    return Board(
      id: id,
      imageURL: imageURL,
      title: title,
      nickName: nickName,
      content: content ?? "",
      createdAt: createdAt.timeAgoDisplay(),
      likeCount: likeCount,
      commnetCount: commnetCount
    )
  }
}

public typealias BoardListResponse = BoardResponse
public typealias BoardFeedResponse = BoardResponse

public enum Category: String {
  case all = "ALL"
  case freeTalk = "FREE_TALK" // 자유잡담
  case franchise = "FRANCHISE"
  case handmade = "HANDMADE"
  case recommendation = "RECOMMENDATION"
}
