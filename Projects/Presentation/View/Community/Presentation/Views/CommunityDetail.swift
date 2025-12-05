//
//  CommunityDetailView.swift
//  Hambug
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI
import DesignSystem

struct CommunityDetailView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var commentText: String = ""
  @State private var isLiked: Bool = false
  @State private var likeCount: Int = 1
  @State private var commentCount: Int = 6
  @State private var showDeletePopup: Bool = false
  
  let post = PostData(
    title: "제목이 들어가는 공간입니다.",
    content: """
        햄버거, 간단히 버거는 속 재료를 잘라낸 빵이나 롤빵 안에 넣어 만든다. 패티에는 종종 치즈, 양상추, 토마토, 양파, 피클, 베이컨, 고추 등이 함께 제공되며, 케첩, 머스터드, 마요네즈, 렐리시 또는 "특별 소스"와 같은 양념이 곁들여지고,
        종종 참깨빵에 담겨 나온다
        """,
    timestamp: "15분 전",
    author: "익명이여기",
    images: ["sample_image_1", "sample_image_2"]
  )
  
  let comments = [
    CommentData(author: "상하이버거", content: "댓글 내용이 들어가는 곳입니다. 햄버거 참말로 맛있겠네요.", timestamp: "15분 전"),
    CommentData(author: "상하이버거", content: "댓글 내용이 들어가는 곳입니다. 햄버거 참말로 맛있겠네요.", timestamp: "15분 전"),
  ]
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        navigationBar
        
        ScrollView {
          VStack(alignment: .leading, spacing: 0) {
            postHeader
            postContent
            imageSection
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
            
          }
        )
        .opacity(showDeletePopup ? 1 : 0)
      )
    }
    .navigationBarHidden(true)
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
      
      
      Circle()
        .fill(Color.bgG200)
        .frame(width: 32, height: 32)
      
      Text("익명이")
        .pretendard(.title(.t2))
        .foregroundColor(.textG900)
      
      Spacer()
      
      EllipsisButton {
        showDeletePopup = true
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.bgWhite)
  }
  
  private var postHeader: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(post.title)
        .pretendard(.title(.t1))
        .foregroundColor(.textG900)
        .multilineTextAlignment(.leading)
      
      Text(post.timestamp)
        .pretendard(.caption(.base))
        .foregroundColor(.textG600)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.top, 20)
  }
  
  private var postContent: some View {
    Text(post.content)
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
        ForEach(0..<3, id: \.self) { index in
          Rectangle()
            .fill(Color.bgG200)
            .frame(width: 270, height: 270)
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
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1
      } label: {
        HStack(spacing: 4) {
          Image(systemName: isLiked ? "heart.fill" : "heart")
            .font(.system(size: 20))
            .foregroundColor(.primaryHambugRed)
          
          Text("\(likeCount)")
            .pretendard(.caption(.base))
            .foregroundColor(.textG600)
        }
      }
      
      HStack(spacing: 4) {
        Image(.communityComment)
          .resizable()
          .frame(width: 20, height: 20)
        
        Text("\(commentCount)")
          .pretendard(.caption(.base))
          .foregroundColor(.textG600)
      }
      
      Spacer()
    }
    .padding(.top, 20)
  }
  
  private var commentSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      ForEach(comments.indices, id: \.self) { index in
        commentRow(comment: comments[index])
      }
    }
  }
  
  private func commentRow(comment: CommentData) -> some View {
    HStack(alignment: .top, spacing: 12) {
      Circle()
        .fill(Color.bgG200)
        .frame(width: 32, height: 32)
      
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(comment.author)
            .pretendard(.body(.sEmphasis))
            .foregroundColor(.textG900)
          
          Spacer()
          
          EllipsisButton {
            
          }
        }
        
        Text(comment.timestamp)
          .pretendard(.caption(.base))
          .foregroundColor(.textG600)
        
        if !comment.content.isEmpty {
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
        // Handle send comment
        if !commentText.isEmpty {
          commentText = ""
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

struct PostData {
  let title: String
  let content: String
  let timestamp: String
  let author: String
  let images: [String]
}

struct CommentData {
  let author: String
  let content: String
  let timestamp: String
}

#Preview {
  CommunityDetailView()
}
