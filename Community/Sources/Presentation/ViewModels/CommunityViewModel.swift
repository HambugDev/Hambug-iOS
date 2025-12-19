//
//  CommunityViewModel.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
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
    
    public var isListView: Bool {
      switch self {
      case .all, .board: true
      case .review, .recommend: false
      }
    }
  }
}
// MARK: - Community ViewModel
public final class CommunityViewModel: ObservableObject {

  // MARK: - Published Properties
  @Published public var boards: [Board] = []
  @Published public var isLoading: Bool = false
  @Published public var errorMessage: String? = nil
  @Published public var selectedCategory: Category = .all

  public var isListView: Bool {
    switch selectedCategory {
    case .all, .board: true
    case .review, .recommend: false
    }
  }
  
  // MARK: - Dependencies
  private let getBoardsUseCase: GetBoardsUseCaseInterface
  
  // MARK: - Private Properties
  private var cancellables = Set<AnyCancellable>()
  private let categories: [Category] = Category.allCases
  
  // MARK: - Initialization
  public init(getBoardsUseCase: GetBoardsUseCaseInterface) {
    self.getBoardsUseCase = getBoardsUseCase
    loadBoards()
  }

  // MARK: - Public Methods
  public func loadBoards() {
    isLoading = true
    errorMessage = nil
    
    getBoardsUseCase.execute()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          self?.isLoading = false
          
          if case .failure(let error) = completion {
            self?.errorMessage = error.localizedDescription
            print("❌ API Error: \(error)")
            
            // API 실패 시 샘플 데이터 사용
            self?.boards = Board.sampleData
          }
        },
        receiveValue: { [weak self] boards in
          print("✅ API Success: \(boards.count) boards loaded")
          self?.boards = boards
        }
      )
      .store(in: &cancellables)
  }
  
  public func refreshBoards() {
    loadBoards()
  }

  public func selectCategory(_ category: Category) {
    selectedCategory = category
  }

  // MARK: - Computed Properties
  public var filteredBoards: [Board] {
    if selectedCategory == .all {
      return boards.isEmpty ? Board.sampleData : boards
    } else {
      // TODO: 실제 카테고리 필터링 로직 구현
      return boards.isEmpty ? Board.sampleData : boards
    }
  }
  
  public var categoryList: [Category] {
    return categories
  }
}
