//
//  Like.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation

// MARK: - Like Info
public struct LikeInfo: Equatable, Sendable {
  public let boardId: Int
  public let likeCount: Int
  public let isLiked: Bool

  public init(boardId: Int, likeCount: Int, isLiked: Bool) {
    self.boardId = boardId
    self.likeCount = likeCount
    self.isLiked = isLiked
  }
}
