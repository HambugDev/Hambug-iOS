//
//  CommunityViewModel.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import SwiftUI
import CommunityDomain

public extension CommunityViewModel {
  enum Category: CaseIterable {
    case all
    case board
    case review
    case recommend

    var title: String {
      switch self {
      case .all:
        "전체"
      case .board:
        "자유잡담"
      case .review:
        "햄버거리뷰"
      case .recommend:
        "맛집추천"
      }
    }

    var boardCategory: BoardCategory? {
      switch self {
      case .all:
        return nil
      case .board:
        return .freeTalk
      case .review:
        return .review
      case .recommend:
        return .recommendation
      }
    }

    public var isListView: Bool {
      switch self {
      case .all, .board: true
      case .review, .recommend: false
      }
    }
  }
}

// MARK: - Community ViewModel
@MainActor
@Observable
public final class CommunityViewModel {

  // MARK: - Published Properties
  public var boards: [Board] = []
  public var isLoading: Bool = false
  public var isLoadingMore: Bool = false
  public var errorMessage: String? = nil
  public var selectedCategory: Category = .all

  public var isListView: Bool {
    switch selectedCategory {
    case .all, .board: true
    case .review, .recommend: false
    }
  }

  // MARK: - Dependencies
  private let getBoardsUseCase: GetBoardsUseCase
  private let getBoardsByCategoryUseCase: GetBoardsByCategoryUseCase

  // MARK: - Private Properties
  private let categories: [Category] = Category.allCases
  private var currentPage: Int? = nil
  private var hasNextPage: Bool = true
  private let pageSize: Int = 10

  // MARK: - Initialization
  public init(
    getBoardsUseCase: GetBoardsUseCase,
    getBoardsByCategoryUseCase: GetBoardsByCategoryUseCase
  ) {
    self.getBoardsUseCase = getBoardsUseCase
    self.getBoardsByCategoryUseCase = getBoardsByCategoryUseCase
    Task {
      await loadBoards()
    }
  }

  // MARK: - Public Methods
  public func loadBoards() async {
    guard !isLoading else { return }
    isLoading = true
    errorMessage = nil
    currentPage = nil
    hasNextPage = true

    do {
      let boardListData: BoardListData

      if let category = selectedCategory.boardCategory {
        boardListData = try await getBoardsByCategoryUseCase.execute(
          category: category,
          lastId: currentPage,
          limit: pageSize,
          order: .desc
        )
      } else {
        boardListData = try await getBoardsUseCase.execute(
          lastId: currentPage,
          limit: pageSize,
          order: .desc
        )
      }

      boards = boardListData.content
      hasNextPage = boardListData.hasNextPage
      if let nextCursor = boardListData.nextCursorId {
        currentPage = nextCursor
      }

      print("✅ API Success: \(boardListData.content.count) boards loaded")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ API Error: \(error)")

      // API 실패 시 샘플 데이터 사용
      boards = Board.sampleData
    }

    isLoading = false
  }

  public func loadMoreBoards() async {
    guard !isLoadingMore && hasNextPage else { return }
    isLoadingMore = true

    do {
      let boardListData: BoardListData

      if let category = selectedCategory.boardCategory {
        boardListData = try await getBoardsByCategoryUseCase.execute(
          category: category,
          lastId: currentPage,
          limit: pageSize,
          order: .desc
        )
      } else {
        boardListData = try await getBoardsUseCase.execute(
          lastId: currentPage,
          limit: pageSize,
          order: .desc
        )
      }

      boards.append(contentsOf: boardListData.content)
      hasNextPage = boardListData.hasNextPage
      if let nextCursor = boardListData.nextCursorId {
        currentPage = nextCursor
      }

      print("✅ Load more success: \(boardListData.content.count) boards added")
    } catch {
      print("❌ Load more error: \(error)")
    }

    isLoadingMore = false
  }

  public func refreshBoards() {
    Task {
      await loadBoards()
    }
  }

  public func selectCategory(_ category: Category) {
    selectedCategory = category
    Task {
      await loadBoards()
    }
  }

  // MARK: - Computed Properties
  public var filteredBoards: [Board] {
    boards
//    return boards.isEmpty ? Board.sampleData : boards
  }

  public var categoryList: [Category] {
    return categories
  }
}
