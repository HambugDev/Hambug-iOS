//
//  CommunityDetailViewModel.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation
import SwiftUI
import CommunityDomain
import Managers

// MARK: - Community Detail ViewModel
@MainActor
@Observable
public final class CommunityDetailViewModel {

  // MARK: - Published Properties
  public var board: Board?
  public var comments: [Comment] = []
  public var likeInfo: LikeInfo?
  public var isLoadingBoard: Bool = false
  public var isLoadingComments: Bool = false
  public var isLoadingMoreComments: Bool = false
  public var errorMessage: String? = nil

  // MARK: - Dependencies
  private let boardDetailUseCase: BoardDetailUseCase
  private let commentUseCase: CommentUseCase
  private let likeUseCase: LikeUseCase
  private let reportContentUseCase: ReportContentUseCase
  private let userDefaultsManager: UserDefaultsManager

  // MARK: - Private Properties
  private var currentCommentPage: Int? = nil
  private var hasNextCommentPage: Bool = true
  private let commentPageSize: Int = 10

  // MARK: - Computed Properties
  public var currentUserId: Int64? {
    userDefaultsManager.currentUserId
  }

  // MARK: - Initialization
  public init(
    boardDetailUseCase: BoardDetailUseCase,
    commentUseCase: CommentUseCase,
    likeUseCase: LikeUseCase,
    reportContentUseCase: ReportContentUseCase,
    userDefaultsManager: UserDefaultsManager
  ) {
    self.boardDetailUseCase = boardDetailUseCase
    self.commentUseCase = commentUseCase
    self.likeUseCase = likeUseCase
    self.reportContentUseCase = reportContentUseCase
    self.userDefaultsManager = userDefaultsManager
  }

  // MARK: - Board Detail Methods
  public func loadBoardDetail(boardId: Int) async {
    guard !isLoadingBoard else { return }
    isLoadingBoard = true
    errorMessage = nil

    do {
      
      board = try await boardDetailUseCase.getBoard(boardId: boardId)
      print("✅ Board detail loaded: \(board?.title ?? "")")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Board detail error: \(error)")
    }

    isLoadingBoard = false
  }
  
  public func deleteBoard(boardId: Int) async {
    errorMessage = nil
    
    do {
      try await boardDetailUseCase.deleteBoard(boardId: boardId)
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Board detail error: \(error)")
    }
  }

  // MARK: - Comment Methods
  public func loadComments(boardId: Int) async {
    guard !isLoadingComments else { return }
    isLoadingComments = true
    errorMessage = nil
    currentCommentPage = nil
    hasNextCommentPage = true

    do {
      let commentListData = try await commentUseCase.getComments(
        boardId: boardId,
        lastId: currentCommentPage,
        limit: commentPageSize,
        order: .desc
      )

      comments = commentListData.content
      hasNextCommentPage = commentListData.hasNextPage
      if let nextCursor = commentListData.nextCursorId {
        currentCommentPage = nextCursor
      }

      print("✅ Comments loaded: \(commentListData.content.count) comments")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Comments error: \(error)")
    }

    isLoadingComments = false
  }

  public func loadMoreComments(boardId: Int) async {
    guard !isLoadingMoreComments && hasNextCommentPage else { return }
    isLoadingMoreComments = true

    do {
      let commentListData = try await commentUseCase.getComments(
        boardId: boardId,
        lastId: currentCommentPage,
        limit: commentPageSize,
        order: .desc
      )

      comments.append(contentsOf: commentListData.content)
      hasNextCommentPage = commentListData.hasNextPage
      if let nextCursor = commentListData.nextCursorId {
        currentCommentPage = nextCursor
      }

      print("✅ Load more comments success: \(commentListData.content.count) comments added")
    } catch {
      print("❌ Load more comments error: \(error)")
    }

    isLoadingMoreComments = false
  }

  public func createComment(boardId: Int, content: String) async {
    guard !content.isEmpty else { return }

    do {
      let newComment = try await commentUseCase.createComment(boardId: boardId, content: content)
      comments.insert(newComment, at: 0)

      // Update board comment count
      if let currentBoard = board {
        var newBoard = currentBoard
        newBoard.commentCount += 1
        board = newBoard
      }

      print("✅ Comment created: \(newComment.content)")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Create comment error: \(error)")
    }
  }

  public func updateComment(boardId: Int, commentId: Int, content: String) async {
    guard !content.isEmpty else { return }

    do {
      let updatedComment = try await commentUseCase.updateComment(
        boardId: boardId,
        commentId: commentId,
        content: content
      )

      if let index = comments.firstIndex(where: { $0.id == commentId }) {
        comments[index] = updatedComment
      }

      print("✅ Comment updated: \(updatedComment.content)")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Update comment error: \(error)")
    }
  }

  public func deleteComment(boardId: Int, commentId: Int) async {
    do {
      try await commentUseCase.deleteComment(boardId: boardId, commentId: commentId)
      comments.removeAll { $0.id == commentId }

      // Update board comment count
      if let currentBoard = board {
        var newBoard = currentBoard
        newBoard.commentCount = max(0, newBoard.commentCount - 1)
        board = newBoard
      }

      print("✅ Comment deleted")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Delete comment error: \(error)")
    }
  }

  // MARK: - Like Methods
  public func loadLikeInfo(boardId: Int) async {
    do {
      likeInfo = try await likeUseCase.getLikeInfo(boardId: boardId)
      print("✅ Like info loaded: \(likeInfo?.likeCount ?? 0) likes")
    } catch {
      print("❌ Like info error: \(error)")
    }
  }

  public func toggleLike(boardId: Int) async {
    do {
      let updatedLikeInfo = try await likeUseCase.toggleLike(boardId: boardId)
      likeInfo = updatedLikeInfo

      // Update board like info
      if let currentBoard = board {
        board = currentBoard
      }

      print("✅ Like toggled: \(updatedLikeInfo.isLiked ? "liked" : "unliked")")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Toggle like error: \(error)")
    }
  }

  // MARK: - Report Methods
  public func reportContent(targetId: Int, targetType: ReportTargetType, reason: String) async {
    let request = ReportRequest(targetId: targetId, targetType: targetType, reason: reason)

    do {
      try await reportContentUseCase.execute(request: request)
      print("✅ Content reported")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Report error: \(error)")
    }
  }
}
