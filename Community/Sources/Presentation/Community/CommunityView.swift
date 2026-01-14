//
//  CommunityView.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import SwiftUI
import DesignSystem
import CommunityDomain
import SharedUI

public protocol CommunityWriteFactory {
  func makeWriteViewModel() -> CommunityWriteViewModelProtocol
}

public protocol CommunityDetailFactory {
  func makeDetailViewModel() -> CommunityDetailViewModel
}

public struct CommunityView: View {
  @State private var viewModel: CommunityViewModel
  private let writeFactory: CommunityWriteFactory
  private let detailFactory: CommunityDetailFactory
  private let updateFactory: UpdateBoardFactory
  private let reportFactory: ReportBoardFactory
  
  public init(
    viewModel: CommunityViewModel,
    writeFactory: CommunityWriteFactory,
    detailFactory: CommunityDetailFactory,
    updateFactory: UpdateBoardFactory,
    reportFactory: ReportBoardFactory
  ) {
    self._viewModel = State(initialValue: viewModel)
    self.writeFactory = writeFactory
    self.detailFactory = detailFactory
    self.updateFactory = updateFactory
    self.reportFactory = reportFactory
  }

  public var body: some View {
      ZStack {
        VStack(spacing: 0) {
          Color.primaryHambugRed
            .frame(height: UIScreen.main.bounds.height * 0.25)
          Color.bgG75
        }
        .ignoresSafeArea(.container, edges: .vertical)
        
        VStack(spacing: 0) {
          // 헤더
          HeaderBar(type: .community)
            .safeAreaPadding(.vertical, 18)
            .safeAreaPadding(.horizontal, 15)
          
          VStack(spacing: 0) {
            // 카테고리 필터와 뷰 토글
            HStack {
              CategoryFilterListView(
                categories: viewModel.categoryList,
                selectedCategory: $viewModel.selectedCategory
              ) { category in
                print("select: \(category.title)")
                viewModel.selectCategory(category)
              }
              
              Spacer()
            }
            .padding(.bottom, 10)
            
            // 컨텐츠 영역
            ZStack {
              if viewModel.isListView {
                CommunityListView(
                  boards: viewModel.filteredBoards,
                  detailFactory: detailFactory,
                  updateFactory: updateFactory,
                  reportFactory: reportFactory,
                  viewModel: viewModel
                )
              } else {
                CommunityFeedView(
                  boards: viewModel.filteredBoards,
                  detailFactory: detailFactory,
                  updateFactory: updateFactory,
                  reportFactory: reportFactory,
                  viewModel: viewModel
                )
              }
            }
          }
          .padding(.horizontal, 20)
        }
        
        // 우측 하단 펜슬 버튼
        VStack {
          Spacer()
          HStack {
            Spacer()
            NavigationLink(
              destination: CommunityWriteView(
                viewModel: writeFactory.makeWriteViewModel()
              )
            ) {
              Color.bgPencil
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .overlay {
                  Image(.communityPencil)
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
          }
        }
      }
      .safeAreaPadding(.bottom, 100)
      .refreshable {
        viewModel.refreshBoards()
      }
      .toolbar(.hidden, for: .navigationBar)
      .tabBarHidden(false)
  }
}

// MARK: - Category Filter
fileprivate struct CategoryFilterListView: View {
  let categories: [CommunityViewModel.Category]
  @Binding var selectedCategory: CommunityViewModel.Category
  let onCategorySelected: (CommunityViewModel.Category) -> Void
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(categories, id: \.self) { category in
        Button(action: {
          selectedCategory = category
          onCategorySelected(category)
        }) {
          CommunityFilterChip(
            category: category.title,
            isSelected: selectedCategory == category
          )
        }
      }
    }
  }
}

fileprivate struct CommunityFilterChip: View {
  let category: String
  let isSelected: Bool
  
  var body: some View {
    Text(category)
      .pretendard(.body(.sEmphasis))
      .foregroundColor(isSelected ? Color.primaryHambugRed : .textG600)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(
        RoundedRectangle(cornerRadius: 6)
          .fill(isSelected ? Color.bgChip : Color.white)
      )
  }
}

// MARK: - List View
public struct CommunityListView: View {
  let boards: [Board]
  let detailFactory: CommunityDetailFactory
  let updateFactory: UpdateBoardFactory
  let reportFactory: ReportBoardFactory
  
  @State private var viewModel: CommunityViewModel

  public init(
    boards: [Board],
    detailFactory: CommunityDetailFactory,
    updateFactory: UpdateBoardFactory,
    reportFactory: ReportBoardFactory,
    viewModel: CommunityViewModel
  ) {
    self.boards = boards
    self.detailFactory = detailFactory
    self.updateFactory = updateFactory
    self.reportFactory = reportFactory
    self._viewModel = State(initialValue: viewModel)
  }

  public var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(Array(boards.enumerated()), id: \.element.id) { index, board in
          NavigationLink(
            destination: CommunityDetailView(
              viewModel: detailFactory.makeDetailViewModel(),
              boardId: board.id,
              updateFactory: updateFactory,
              reportFactory: reportFactory
            )) {
            CommunityPostListCard(board: board)
          }
          .buttonStyle(PlainButtonStyle())
          .onAppear {
            // 마지막에서 3개 전부터 미리 로드 시작
            if index >= boards.count - 3 {
              Task {
                await viewModel.loadMoreBoards()
              }
            }
          }
        }

        if viewModel.isLoadingMore {
          HStack {
            Spacer()
            ProgressView()
            Spacer()
          }
          .padding(.vertical, 16)
        }
      }
      .cornerRadius(8)
      .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    .scrollIndicators(.hidden)
    .cornerRadius(8)
    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
  }
}

// MARK: - Feed View
fileprivate struct CommunityFeedView: View {
  let boards: [Board]
  let detailFactory: CommunityDetailFactory
  let updateFactory: UpdateBoardFactory
  let reportFactory: ReportBoardFactory
  
  @State private var viewModel: CommunityViewModel

  init(
    boards: [Board],
    detailFactory: CommunityDetailFactory,
    updateFactory: UpdateBoardFactory,
    reportFactory: ReportBoardFactory,
    viewModel: CommunityViewModel
  ) {
    self.boards = boards
    self.detailFactory = detailFactory
    self.updateFactory = updateFactory
    self.reportFactory = reportFactory
    self._viewModel = State(initialValue: viewModel)
  }

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(Array(boards.enumerated()), id: \.element.id) { index, board in
          NavigationLink(
            destination: CommunityDetailView(
              viewModel: detailFactory.makeDetailViewModel(),
              boardId: board.id,
              updateFactory: updateFactory,
              reportFactory: reportFactory
            )
          ) {
            CommunityPostFeedCard(board: board)
          }
          .buttonStyle(PlainButtonStyle())
          .onAppear {
            // 마지막에서 3개 전부터 미리 로드 시작
            if index >= boards.count - 3 {
              Task {
                await viewModel.loadMoreBoards()
              }
            }
          }
        }

        if viewModel.isLoadingMore {
          HStack {
            Spacer()
            ProgressView()
            Spacer()
          }
          .padding(.vertical, 16)
        }
      }
      .padding(.top, 8)
    }
  }
}

// MARK: - List Card
fileprivate struct CommunityPostListCard: View {
  let board: Board
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(alignment: .top, spacing: 12) {
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            Text(board.title)
              .pretendard(.body(.base))
              .foregroundColor(Color.textG800)
              .lineLimit(1)
              .truncationMode(.tail)
              .padding(.trailing, 8)

            Text(board.createdAt)
              .pretendard(.caption(.base))
              .foregroundColor(Color.textG600)

            Spacer()
          }

          HStack(spacing: 4) {
            Text(board.authorNickname)
              .pretendard(.caption(.base))
              .foregroundColor(Color.textG800)

            HStack(spacing: 4) {
              Image(systemName: "heart.fill")
                .foregroundColor(Color.textR100)
                .font(.system(size: 12))

              Text("\(board.likeCount)")
                .pretendard(.caption(.base))
                .foregroundColor(Color.textG600)

              Image(.communityCommentFill)
                .resizable()
                .frame(width: 12, height: 12)

              Text("\(board.commentCount)")
                .pretendard(.caption(.base))
                .foregroundColor(Color.textG600)
            }
          }
        }

        AsyncThumbnailImage(
          imageURL: board.imageUrls.first ?? "",
          width: 50,
          height: 50,
          cornerRadius: 8
        )
        
      }
      .padding(16)
      .background(Color.white)
    }
  }
}

// MARK: - Feed Card
fileprivate struct CommunityPostFeedCard: View {
  let board: Board

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {

      AsyncThumbnailImage(
        imageURL: board.imageUrls.first ?? "",
        height: 192,
        cornerRadius: 8
      )
      
      HStack(spacing: 8) {
        Text(board.title)
          .pretendard(.body(.bEmphasis))
          .foregroundColor(Color.textG800)
          .multilineTextAlignment(.leading)
          .lineLimit(1)

        Spacer()

        Text(board.createdAt)
          .pretendard(.caption(.base))
          .foregroundColor(Color.textG600)
      }

      HStack {
        Text(board.authorNickname)
          .pretendard(.caption(.base))
          .foregroundColor(Color.textG800)

        HStack(spacing: 4) {
          Image(systemName: "heart.fill")
            .foregroundColor(Color.textR100)
            .font(.system(size: 12))

          Text("\(board.likeCount)")
            .pretendard(.caption(.base))
            .foregroundColor(Color.textG600)

          Image(.communityCommentFill)
            .resizable()
            .frame(width: 12, height: 12)

          Text("\(board.commentCount)")
            .pretendard(.caption(.base))
            .foregroundColor(Color.textG600)
        }
        Spacer()
      }
      Text(board.content)
        .pretendard(.body(.base))
        .foregroundColor(Color.textG800)
        .lineLimit(3)
        .truncationMode(.tail)
        .multilineTextAlignment(.leading)
    }
    .padding(16)
    .background(Color.white)
    .cornerRadius(8)
    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
  }
}


