//
//  CommunityViewModel.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import SwiftUI

extension CommunityViewModel {
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
    
    var isListView: Bool {
      switch self {
      case .all, .board: true
      case .review, .recommend: false
      }
    }
  }
}
// MARK: - Community ViewModel
final class CommunityViewModel: ObservableObject {
  
  // MARK: - Published Properties
  @Published var boards: [Board] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String? = nil
  @Published var selectedCategory: Category = .all
  
  var isListView: Bool {
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
  init(getBoardsUseCase: GetBoardsUseCaseInterface) {
    self.getBoardsUseCase = getBoardsUseCase
    loadBoards()
  }
  
  // MARK: - Public Methods
  func loadBoards() {
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
  
  func refreshBoards() {
    loadBoards()
  }
  
  func selectCategory(_ category: Category) {
    selectedCategory = category
  }
  
  // MARK: - Computed Properties
  var filteredBoards: [Board] {
    if selectedCategory == .all {
      return boards.isEmpty ? Board.sampleData : boards
    } else {
      // TODO: 실제 카테고리 필터링 로직 구현
      return boards.isEmpty ? Board.sampleData : boards
    }
  }
  
  var categoryList: [Category] {
    return categories
  }
}
