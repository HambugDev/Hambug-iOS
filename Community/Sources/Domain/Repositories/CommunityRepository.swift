//
//  CommunityRepositoryInterface.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import NetworkInterface
import UIKit

// MARK: - Community Repository Interface
public protocol CommunityRepository: Sendable {
  // 게시글 조회
  func fetchBoards(lastId: Int?, limit: Int, order: SortOrder) async throws -> BoardListData
  func fetchBoardsByCategory(_ category: BoardCategory, lastId: Int?, limit: Int, order: SortOrder) async throws -> BoardListData
  func fetchBoardDetail(boardId: Int) async throws -> Board

  // 게시글 생성
  func createBoard(
    title: String,
    content: String,
    category: BoardCategory,
    images: [UIImage]
  ) async throws -> Board

  // 댓글
  func fetchComments(boardId: Int, lastId: Int, limit: Int, order: SortOrder) async throws -> CommentListData
  func createComment(boardId: Int, content: String) async throws -> Comment
  func updateComment(boardId: Int, commentId: Int, content: String) async throws -> Comment
  func deleteComment(boardId: Int, commentId: Int) async throws

  // 좋아요
  func fetchLikeInfo(boardId: Int) async throws -> LikeInfo
  func toggleLike(boardId: Int) async throws -> LikeInfo

  // 신고
  func reportContent(request: ReportRequest) async throws
}
