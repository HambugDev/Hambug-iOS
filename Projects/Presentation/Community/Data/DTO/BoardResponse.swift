//
//  BoardResponse.swift
//  Hambug
//
//  Created by 강동영 on 10/27/25.
//

import Foundation

// MARK: - Unified Board Response Model
struct BoardResponse: Decodable {
  let id: Int
  let imageURL: String
  let title: String
  let nickName: String
  let content: String?    // 목록 조회시 nil, 카테고리에 따라 조회시 값
  let createdAt: Date
  let likeCount: String
  let commnetCount: String
}

typealias BoardListResponse = BoardResponse
typealias BoardFeedResponse = BoardResponse

enum Category: String {
  case all = "ALL"
  case freeTalk = "FREE_TALK" // 자유잡담
  case franchise = "FRANCHISE"
  case handmade = "HANDMADE"
  case recommendation = "RECOMMENDATION"
}
