//
//  MyActivitiesView.swift
//  MyPage
//
//  Created by 강동영 on 12/19/25.
//

import SwiftUI
import DesignSystem
import CommunityDomain
import MyPageDomain
import SharedUI
import CommunityDI
import CommunityPresentation

public struct MyActivitiesView: View {
  @State private var viewModel: MyActivitiesViewModel

  private let communityDIContainer: CommunityDIContainer
  
  public init(viewModel: MyActivitiesViewModel) {
    self._viewModel = State(initialValue: viewModel)
    self.communityDIContainer = .init(appContainer: .shared)
  }

  public var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        navigationBar
        tabBar
        contentView
      }
      .background(Color.bgG75)
    }
    .navigationBarHidden(true)
    .refreshable {
      viewModel.refreshCurrentTab()
    }
  }

  private var navigationBar: some View {
    HambugNavigationView() {
      Text("활동내역")
        .pretendard(.title(.t2))
        .foregroundStyle(Color.textG900)
        .padding(.leading, 8)
    }
  }

  private var tabBar: some View {
    HStack(spacing: 0) {
      TabButton(
        title: "게시글",
        isSelected: viewModel.selectedTab == .posts,
        action: { viewModel.selectedTab = .posts }
      )

      TabButton(
        title: "댓글",
        isSelected: viewModel.selectedTab == .comments,
        action: { viewModel.selectedTab = .comments }
      )
    }
    .padding(.horizontal, 16)
  }

  @ViewBuilder
  private var contentView: some View {
    if viewModel.selectedTab == .posts {
      CommunityListView(
        boards: viewModel.myBoards,
        detailFactory: communityDIContainer,
        updateFactory: communityDIContainer,
        reportFactory: communityDIContainer,
        viewModel: communityDIContainer.makeCommunityViewModel()
      )
      .padding(.horizontal, 20)
      .padding(.vertical, 12)
    } else {
      MyCommentsListView(
        communityDIContainer: communityDIContainer,
        comments: viewModel.myComments,
        isLoadingMore: viewModel.isLoadingMoreComments,
        onLoadMore: { index in
          if index >= viewModel.myComments.count - 3 {
            Task { await viewModel.loadMoreComments() }
          }
        }
      )
      .padding(.horizontal, 20)
      .padding(.vertical, 12)
    }
  }
}

// MARK: - MyActivitiesView's ActivityTab
extension MyActivitiesView {
  enum ActivityTab {
    case posts
    case comments
  }
}

// MARK: - Tab Button
struct TabButton: View {
  let title: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 8) {
        Text(title)
          .pretendard(.body(.base))
          .foregroundColor(isSelected ? .primaryHambugRed : .textG600)

        Rectangle()
          .frame(height: 2)
          .foregroundColor(isSelected ? .primaryHambugRed : .borderG400)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 12)
  }
}

// MARK: - 게시글 리스트 뷰
struct MyBoardsListView: View {
  let boards: [Board]
  let isLoadingMore: Bool
  let onLoadMore: (Int) -> Void

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(Array(boards.enumerated()), id: \.element.id) { index, board in
          NavigationLink(destination: Text("Board Detail \(board.id)")) {
            MyBoardListCard(board: board)
          }
          .buttonStyle(PlainButtonStyle())
          .onAppear { onLoadMore(index) }
        }

        if isLoadingMore {
          HStack {
            Spacer()
            ProgressView()
            Spacer()
          }
          .padding(.vertical, 16)
        }
      }
    }
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 4.5, x: 0, y: 0)
    )
  }
}

// MARK: - 게시글 카드
fileprivate struct MyBoardListCard: View {
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
            Text(board.authorNickname ?? "authorNickname nil")
              .pretendard(.caption(.base))
              .foregroundColor(Color.textG800)

            HStack(spacing: 4) {
              Image(systemName: "heart.fill")
                .foregroundColor(Color.textR100)
                .font(.system(size: 12))

              Text("\(board.likeCount)")
                .pretendard(.caption(.base))
                .foregroundColor(Color.textG600)

              Image("community_comment_fill", bundle: .main)
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

// MARK: - 댓글 리스트 뷰
struct MyCommentsListView: View {
  let communityDIContainer: CommunityDIContainer
  let comments: [MyCommentActivity]
  let isLoadingMore: Bool
  let onLoadMore: (Int) -> Void
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(Array(comments.enumerated()), id: \.element.id) { index, comment in
          NavigationLink(
            destination: CommunityDetailView(
              viewModel: communityDIContainer.makeDetailViewModel(),
              boardId: Int(comment.boardId),
              updateFactory: communityDIContainer,
              reportFactory: communityDIContainer
            )) {
            MyCommentActivityCard(comment: comment)
          }
          .buttonStyle(PlainButtonStyle())
          .onAppear { onLoadMore(index) }
        }

        if isLoadingMore {
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

// MARK: - 댓글 카드
fileprivate struct MyCommentActivityCard: View {
  let comment: MyCommentActivity

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        Text(comment.boardTitle)
          .pretendard(.body(.base))
          .foregroundColor(Color.textG800)
          .lineLimit(1)
          .truncationMode(.tail)

        Spacer()

        Text(comment.createdAt)
          .pretendard(.caption(.base))
          .foregroundColor(Color.textG600)
      }

      HStack(spacing: 4) {
        Image("community_comment", bundle: .main)
          .resizable()
          .foregroundColor(.white)
          .frame(width: 12, height: 12)

        Text(comment.content)
          .pretendard(.caption(.base))
          .foregroundColor(Color.textG600)
          .lineLimit(2)
          .truncationMode(.tail)
      }
    }
    .padding(16)
    .background(Color.white)
  }
}

// MARK: - Hambug Navigation View
struct HambugNavigationView<Content: View>: View {
  @Environment(\.presentationMode) var presentationMode
  @ViewBuilder var content: () -> Content

  var body: some View {
    HStack {
      Button(action: {
        presentationMode.wrappedValue.dismiss()
      }) {
        Image(systemName: "chevron.left")
          .foregroundColor(.textG900)
          .frame(width: 24, height: 24)
      }
      .padding(.leading, 16)

      content()

      Spacer()
    }
    .padding(.vertical, 12)
  }
}

#Preview {
  // Preview requires mocked dependencies
  MyActivitiesView(
    viewModel: MyActivitiesViewModel(
      getMyBoardsUseCase: MockGetMyBoardsUseCase(),
      getMyCommentsUseCase: MockGetMyCommentsUseCase()
    )
  )
}

// MARK: - Mock UseCases for Preview
private final class MockGetMyBoardsUseCase: GetMyBoardsUseCase {
  func execute(lastId: Int?, limit: Int, order: String) async throws -> BoardListData {
    return BoardListData(content: [], nextCursorId: nil, hasNextPage: false)
  }
}

private final class MockGetMyCommentsUseCase: GetMyCommentsUseCase {
  func execute(lastId: Int?, limit: Int, order: String) async throws -> MyCommentActivityListData {
    return MyCommentActivityListData(content: [], nextCursorId: nil, hasNextPage: false)
  }
}
