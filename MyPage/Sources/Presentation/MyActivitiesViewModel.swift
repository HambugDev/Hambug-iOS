//
//  MyActivitiesViewModel.swift
//  MyPage
//
//  Created by 강동영 on 12/19/25.
//

import Foundation
import CommunityDomain
import MyPageDomain

@MainActor
@Observable
public final class MyActivitiesViewModel {

  // MARK: - Published Properties
  public var myBoards: [Board] = []
  public var myComments: [MyCommentActivity] = []

  public var isLoadingBoards: Bool = false
  public var isLoadingMoreBoards: Bool = false

  public var isLoadingComments: Bool = false
  public var isLoadingMoreComments: Bool = false

  public var errorMessage: String? = nil
  public var selectedTab: ActivityTab = .posts

  // MARK: - Dependencies
  private let getMyBoardsUseCase: GetMyBoardsUseCase
  private let getMyCommentsUseCase: GetMyCommentsUseCase

  // MARK: - Private Properties
  private var boardsCurrentPage: Int? = nil
  private var boardsHasNextPage: Bool = true
  private let pageSize: Int = 10

  private var commentsCurrentPage: Int? = nil
  private var commentsHasNextPage: Bool = true

  // MARK: - Initialization
  public init(
    getMyBoardsUseCase: GetMyBoardsUseCase,
    getMyCommentsUseCase: GetMyCommentsUseCase
  ) {
    self.getMyBoardsUseCase = getMyBoardsUseCase
    self.getMyCommentsUseCase = getMyCommentsUseCase

    Task {
      await loadBoards()
      await loadComments()
    }
  }

  // MARK: - Public Methods - Boards
  public func loadBoards() async {
    guard !isLoadingBoards else { return }
    isLoadingBoards = true
    errorMessage = nil
    boardsCurrentPage = nil
    boardsHasNextPage = true

    do {
      let boardListData = try await getMyBoardsUseCase.execute(
        lastId: boardsCurrentPage,
        limit: pageSize,
        order: "DESC"
      )

      myBoards = boardListData.content
      boardsHasNextPage = boardListData.hasNextPage
      boardsCurrentPage = boardListData.nextCursorId
    } catch {
      errorMessage = error.localizedDescription
    }

    isLoadingBoards = false
  }

  public func loadMoreBoards() async {
    guard !isLoadingMoreBoards && boardsHasNextPage else { return }
    isLoadingMoreBoards = true

    do {
      let boardListData = try await getMyBoardsUseCase.execute(
        lastId: boardsCurrentPage,
        limit: pageSize,
        order: "DESC"
      )

      myBoards.append(contentsOf: boardListData.content)
      boardsHasNextPage = boardListData.hasNextPage
      boardsCurrentPage = boardListData.nextCursorId
    } catch {
      print("❌ Load more boards error: \(error)")
    }

    isLoadingMoreBoards = false
  }

  // MARK: - Public Methods - Comments
  public func loadComments() async {
    guard !isLoadingComments else { return }
    isLoadingComments = true
    errorMessage = nil
    commentsCurrentPage = nil
    commentsHasNextPage = true

    do {
      let commentListData = try await getMyCommentsUseCase.execute(
        lastId: commentsCurrentPage,
        limit: pageSize,
        order: "DESC"
      )

      myComments = commentListData.content
      commentsHasNextPage = commentListData.hasNextPage
      commentsCurrentPage = commentListData.nextCursorId
    } catch {
      errorMessage = error.localizedDescription
    }

    isLoadingComments = false
  }

  public func loadMoreComments() async {
    guard !isLoadingMoreComments && commentsHasNextPage else { return }
    isLoadingMoreComments = true

    do {
      let commentListData = try await getMyCommentsUseCase.execute(
        lastId: commentsCurrentPage,
        limit: pageSize,
        order: "DESC"
      )

      myComments.append(contentsOf: commentListData.content)
      commentsHasNextPage = commentListData.hasNextPage
      commentsCurrentPage = commentListData.nextCursorId
    } catch {
      print("❌ Load more comments error: \(error)")
    }

    isLoadingMoreComments = false
  }

  public func refreshCurrentTab() {
    Task {
      if selectedTab == .posts {
        await loadBoards()
      } else {
        await loadComments()
      }
    }
  }

  // MARK: - ActivityTab Enum
  public enum ActivityTab {
    case posts
    case comments
  }
}
