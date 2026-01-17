//
//  CommunityDetail.swift
//  Hambug
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI
import DesignSystem
import CommunityDomain
import SharedUI

public protocol UpdateBoardFactory {
  func makeViewModel(boardId: Int) -> CommunityWriteViewModelProtocol
}
public protocol ReportBoardFactory {
  func makeViewModel(req: ReportRequest) -> CommunityReportViewModel
}

public struct CommunityDetailView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: CommunityDetailViewModel
  @State private var commentText: String = ""
  @State private var showDeletePopup: Bool = false

  // Comment action states
  @State private var selectedComment: Comment?
  @State private var showCommentActionSheet: Bool = false
  @State private var showDeleteCommentAlert: Bool = false
  @State private var editingCommentId: Int?
  @State private var editingCommentText: String = ""

  // Board action states
  @State private var showBoardActionSheet: Bool = false

  // Report states
  @State private var reportTargetId: Int?
  @State private var reportTargetType: ReportTargetType?
  @State private var reportReason: String = ""

  private let boardId: Int
  private let dependency: CommunityDetailDependency
  public init(
    dependency: CommunityDetailDependency,
    boardId: Int
  ) {
    _viewModel = State(initialValue: dependency.makeDetailViewModel())
    self.boardId = boardId
    self.dependency = dependency
  }
  
  public var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        navigationBar

        ScrollView {
          VStack(alignment: .leading, spacing: 0) {
            postHeader
            postContent

            if !(viewModel.board?.imageUrls.isEmpty ?? true) {
              imageSection
            }

            likeCommentSection
            Divider()
              .background(Color.borderG300)
              .padding(.vertical, 16)
            commentSection
          }
          .padding(.horizontal, 16)
        }

        commentInputSection
      }
      .background(Color.bgWhite)
      .overlay(
        HambugCommonAlertView(
          isPresented: $showDeletePopup,
          content: {
            Text("게시물을 삭제하시겠어요?")
              .pretendard(.title(.t2))
              .foregroundStyle(Color.textG900)
              .padding(.top, 16)
          },
          secondaryButton: AlertButton(title: "취소") {
            print("취소")

          },
          primaryButton: AlertButton(title: "삭제") {
            print("삭제")
            Task {
              await viewModel.deleteBoard(boardId: boardId)
              dismiss()
            }
          }
        )
        .opacity(showDeletePopup ? 1 : 0)
      )
      .tabBarHidden(true)
      .onAppear {
        Task {
          await viewModel.loadBoardDetail(boardId: boardId)
          await viewModel.loadComments(boardId: boardId)
          await viewModel.loadLikeInfo(boardId: boardId)
        }
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .confirmationDialog("댓글", isPresented: $showCommentActionSheet, presenting: selectedComment) { comment in
      // Only show edit/delete buttons if the current user is the author
      if let currentUserId = viewModel.currentUserId,
         Int64(comment.authorId) == currentUserId {
        Button("수정") {
          editingCommentId = comment.id
          editingCommentText = comment.content
        }
        Button("삭제", role: .destructive) {
          selectedComment = comment
          showDeleteCommentAlert = true
        }
      }

      // Only show report button if the current user is NOT the author
      if let currentUserId = viewModel.currentUserId,
         Int64(comment.authorId) != currentUserId {
        NavigationLink(
          destination: CommunityReportView(
            viewModel: dependency.makeViewModel(
              req: CommunityDomain.ReportRequest.init(
                targetId: comment.id,
                targetType: .comment,
                reason: ""
              )
            )
          )
        ) {
          Text("신고")
        }
      }

      Button("취소", role: .cancel) {}
    }
    .confirmationDialog("게시물", isPresented: $showBoardActionSheet) {
      // Only show delete button if the current user is the author
      if let currentUserId = viewModel.currentUserId,
         let authorId = viewModel.board?.authorId,
         Int64(authorId) == currentUserId {
        NavigationLink(
          destination: CommunityWriteView(
            viewModel: dependency.makeViewModel(boardId: boardId),
            title: viewModel.board?.title ?? "",
            content: viewModel.board?.content ?? ""
          )
        ) {
          Button("수정") {
          }
        }
        
        Button("삭제", role: .destructive) {
          showDeletePopup = true
        }
      }

      // Only show report button if the current user is NOT the author
      if let currentUserId = viewModel.currentUserId,
         let authorId = viewModel.board?.authorId,
         Int64(authorId) != currentUserId {
        NavigationLink(
          destination: CommunityReportView(
            viewModel: dependency.makeViewModel(
              req: CommunityDomain.ReportRequest.init(
                targetId: boardId,
                targetType: .board,
                reason: ""
              )
            )
          )
        ) {
          Text("신고")
        }
      }

      Button("취소", role: .cancel) {}
    }
    .alert("댓글 삭제", isPresented: $showDeleteCommentAlert, presenting: selectedComment) { comment in
      Button("취소", role: .cancel) {}
      Button("삭제", role: .destructive) {
        Task {
          await viewModel.deleteComment(boardId: boardId, commentId: comment.id)
        }
      }
    } message: { _ in
      Text("댓글을 삭제하시겠어요?")
    }
  }
  
  private var navigationBar: some View {
    HStack {
      Button {
        dismiss()
      } label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(.iconG800)
      }

      ProfileImageView(with: viewModel.board?.authorProfileImageUrl ?? "")
        .applyCilpShape()

      Text(viewModel.board?.authorNickname ?? "")
        .pretendard(.title(.t2))
        .foregroundColor(.textG900)

      Spacer()

      EllipsisButton {
        showBoardActionSheet = true
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.bgWhite)
  }
  
  private var postHeader: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(viewModel.board?.title ?? "")
        .pretendard(.title(.t1))
        .foregroundColor(.textG900)
        .multilineTextAlignment(.leading)

      Text(viewModel.board?.createdAt ?? "")
        .pretendard(.caption(.base))
        .foregroundColor(.textG600)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.top, 20)
  }

  private var postContent: some View {
    Text(viewModel.board?.content ?? "")
      .pretendard(.body(.base))
      .foregroundColor(.textG800)
      .lineLimit(nil)
      .multilineTextAlignment(.leading)
      .allowsTightening(true)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 16)
  }
  
  private var imageSection: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 12) {
        ForEach(viewModel.board?.imageUrls ?? [], id: \.self) { imageUrl in
          AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
              Rectangle()
                .fill(Color.bgG200)
                .frame(width: 270, height: 270)
                .overlay {
                  ProgressView()
                }
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 270, height: 270)
                .clipped()
            case .failure:
              Rectangle()
                .fill(Color.bgG200)
                .frame(width: 270, height: 270)
            @unknown default:
              Rectangle()
                .fill(Color.bgG200)
                .frame(width: 270, height: 270)
            }
          }
          .cornerRadius(8)
        }
      }
    }
    .scrollIndicators(.hidden)
    .padding(.top, 20)

  }
  
  private var likeCommentSection: some View {
    HStack(spacing: 16) {
      Button {
        Task {
          await viewModel.toggleLike(boardId: boardId)
        }
      } label: {
        HStack(spacing: 4) {
          Image(systemName: (viewModel.likeInfo?.isLiked ?? false) ? "heart.fill" : "heart")
            .font(.system(size: 20))
            .foregroundColor(.primaryHambugRed)

          Text("\(viewModel.likeInfo?.likeCount ?? 0)")
            .pretendard(.caption(.base))
            .foregroundColor(.textG600)
        }
      }

      HStack(spacing: 4) {
        Image(.communityCommentFill)
          .resizable()
          .frame(width: 20, height: 20)

        Text("\(viewModel.board?.commentCount ?? 0)")
          .pretendard(.caption(.base))
          .foregroundColor(.textG600)
      }

      Spacer()
    }
    .padding(.top, 20)
  }
  
  private var commentSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      // 코멘트 헤더
      Text("댓글 \(viewModel.comments.count)")
        .pretendard(.body(.bEmphasis))
        .foregroundColor(.textG900)

      if viewModel.comments.isEmpty {
        // 댓글이 없을 때
        VStack(spacing: 8) {
          Spacer()
            .frame(height: 40)
          Text("첫 댓글을 남겨보세요")
            .pretendard(.body(.base))
            .foregroundColor(.textG600)
          Spacer()
            .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
      } else {
        // 댓글이 있을 때
        ForEach(Array(viewModel.comments.enumerated()), id: \.element.id) { index, comment in
          commentRow(comment: comment)
            .onAppear {
              if index == viewModel.comments.count - 1 {
                Task {
                  await viewModel.loadMoreComments(boardId: boardId)
                }
              }
            }
        }
      }

      if viewModel.isLoadingMoreComments {
        HStack {
          Spacer()
          ProgressView()
          Spacer()
        }
        .padding(.vertical, 8)
      }
    }
  }
  
  private func commentRow(comment: Comment) -> some View {
    HStack(alignment: .top, spacing: 12) {
      ProfileImageView(with: comment.authorProfileImageUrl ?? "")
        .applyCilpShape()

      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(comment.authorNickname)
            .pretendard(.body(.sEmphasis))
            .foregroundColor(.textG900)

          Spacer()

          EllipsisButton {
            selectedComment = comment
            showCommentActionSheet = true
          }
        }

        Text(timeAgoDisplay(comment.createdAt))
          .pretendard(.caption(.base))
          .foregroundColor(.textG600)

        if editingCommentId == comment.id {
          HStack {
            TextField("댓글 수정", text: $editingCommentText)
              .pretendard(.body(.base))
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(
                RoundedRectangle(cornerRadius: 8)
                  .fill(Color.bgG100)
              )

            Button("완료") {
              Task {
                await viewModel.updateComment(boardId: boardId, commentId: comment.id, content: editingCommentText)
                editingCommentId = nil
                editingCommentText = ""
              }
            }
            .pretendard(.body(.sEmphasis))
            .foregroundColor(.primaryHambugRed)

            Button("취소") {
              editingCommentId = nil
              editingCommentText = ""
            }
            .pretendard(.body(.base))
            .foregroundColor(.textG600)
          }
          .padding(.top, 4)
        } else if !comment.content.isEmpty {
          Text(comment.content)
            .pretendard(.body(.base))
            .foregroundColor(.textG800)
            .multilineTextAlignment(.leading)
            .padding(.top, 4)
        }
      }
    }
  }
  
  private var commentInputSection: some View {
    HStack(spacing: 12) {
      TextField("댓글을 입력하세요", text: $commentText)
        .pretendard(.body(.base))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(Color.bgG100)
        )
      
      Button {
        if !commentText.isEmpty {
          Task {
            await viewModel.createComment(boardId: boardId, content: commentText)
            commentText = ""
          }
        }
      } label: {
        Image(systemName: "paperplane.fill")
          .font(.system(size: 16))
          .foregroundColor(.primaryHambugRed)
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.bgWhite)
    .overlay(
      Rectangle()
        .frame(height: 1)
        .foregroundColor(.borderG300),
      alignment: .top
    )
  }

  private func timeAgoDisplay(_ date: Date) -> String {
    let now = Date()
    let timeInterval = now.timeIntervalSince(date)

    if timeInterval < 60 {
      return "방금 전"
    } else if timeInterval < 3600 {
      let minutes = Int(timeInterval / 60)
      return "\(minutes)분 전"
    } else if timeInterval < 86400 {
      let hours = Int(timeInterval / 3600)
      return "\(hours)시간 전"
    } else if timeInterval < 604800 {
      let days = Int(timeInterval / 86400)
      return "\(days)일 전"
    } else {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd"
      return formatter.string(from: date)
    }
  }
}

struct EllipsisButton: View {
  private let action: () -> Void
  var body: some View {
    Button {
      action()
    } label: {
      Color.bgEllipsis
        .frame(width: 24, height: 24)
        .clipShape(Circle())
        .overlay {
          Image(systemName: "ellipsis")
            .rotationEffect(.degrees(90.0))
            .font(.system(size: 14))
            .foregroundColor(.iconG600)
        }
    }
  }
  
  init(action: @escaping @MainActor () -> Void) {
    self.action = action
  }
}

// Preview requires mock ViewModel with all dependencies
// #Preview {
//   CommunityDetailView(viewModel: mockViewModel, boardId: 1)
// }
