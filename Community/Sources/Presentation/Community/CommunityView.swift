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
  func makeWriteViewModel() -> CommunityWriteViewModel
public protocol CommunityDetailFactory {
  func makeDetailViewModel() -> CommunityDetailViewModel
}

public struct CommunityView: View {
  @State private var viewModel: CommunityViewModel
  private let factory: CommunityWriteFactory
  private let detailFactory: CommunityDetailFactory
  
  public init(
    viewModel: CommunityViewModel,
    factory: CommunityWriteFactory
    detailFactory: CommunityDetailFactory,
  ) {
    self._viewModel = State(initialValue: viewModel)
    self.factory = factory
    self.detailFactory = detailFactory
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
          CommunityHeader()
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
          
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
                  detailFactory: detailFactory
                )
              } else {
                CommunityFeedView(
                  boards: viewModel.filteredBoards,
                  detailFactory: detailFactory
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
                viewModel: factory.makeWriteViewModel()
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
      .navigationBarHidden(true)
      .tabBarHidden(false)
  }
}

// MARK: - Category Header
struct CommunityHeader: View {
  var body: some View {
    HStack {
      Text("커뮤니티")
        .pretendard(.title(.t2))
        .foregroundColor(.white)
      
      Spacer()
      
      Button(action: {
        print("Notification tapped")
      }) {
        Image(.naviBell)
          .resizable()
          .foregroundColor(.white)
          .frame(width: 20, height: 20)
      }
    }
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
struct CommunityListView: View {
  let boards: [Board]
  let detailFactory: CommunityDetailFactory
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(Array(boards.enumerated()), id: \.element.id) { index, board in
          NavigationLink(
            destination: CommunityDetailView(
              viewModel: detailFactory.makeDetailViewModel(),
              boardId: board.id
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
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(boards) { board in
        ForEach(Array(boards.enumerated()), id: \.element.id) { index, board in
          NavigationLink(
            destination: CommunityDetailView(
              viewModel: detailFactory.makeDetailViewModel(),
              boardId: board.id
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

              Image(.communityComment)
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

          Image(.communityComment)
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

struct AsyncThumbnailImage: View {
  private let imageURL: String?
  private let width: CGFloat?
  private let height: CGFloat?
  private let cornerRadius: CGFloat
  
  init(
    imageURL: String?,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    cornerRadius: CGFloat = 8
  ) {
    self.imageURL = imageURL
    self.width = width
    self.height = height
    self.cornerRadius = cornerRadius
  }
  
  var body: some View {
    content
      .frame(width: width, height: height)
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
  }
  
  @ViewBuilder
  private var content: some View {
    if let imageURL = imageURL,
       !imageURL.isEmpty,
       let url = URL(string: imageURL) {
      AsyncImage(url: url) { phase in
        if case .success(let image) = phase {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        }
      }
    }
  }
}
