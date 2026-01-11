//
//  CommunityAPIClient.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import Combine
import NetworkInterface
import CommunityDomain
import UIKit

// MARK: - Community API Client Interface
public protocol CommunityAPIClientInterface: Sendable {
  func fetchBoards(lastId: Int?, limit: Int, order: String) -> AnyPublisher<BoardListDataDTO, NetworkError>
  func fetchBoardsByCategory(category: String, lastId: Int?, limit: Int, order: String) -> AnyPublisher<BoardListDataDTO, NetworkError>
  func fetchBoardDetail(boardId: Int) -> AnyPublisher<BoardDetailResponseDTO, NetworkError>

  // Board creation
  func createBoard(
    title: String,
    content: String,
    category: String,
    images: [UIImage]
  ) -> AnyPublisher<BoardResponseDTO, NetworkError>

  // Comments
  func fetchComments(boardId: Int, lastId: Int?, limit: Int, order: String) -> AnyPublisher<CommentListDataDTO, NetworkError>
  func createComment(boardId: Int, content: String) -> AnyPublisher<CommentResponseDTO, NetworkError>
  func updateComment(boardId: Int, commentId: Int, content: String) -> AnyPublisher<CommentResponseDTO, NetworkError>
  func deleteComment(boardId: Int, commentId: Int) -> AnyPublisher<Void, NetworkError>

  // Likes
  func fetchLikeInfo(boardId: Int) -> AnyPublisher<LikeResponseDTO, NetworkError>
  func toggleLike(boardId: Int) -> AnyPublisher<LikeResponseDTO, NetworkError>

  // Report
  func reportContent(request: ReportRequestDTO) -> AnyPublisher<Void, NetworkError>
}

// MARK: - Community API Client Implementation
public final class CommunityAPIClient: CommunityAPIClientInterface {

  private let networkService: NetworkServiceInterface

  public init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }

  public func fetchBoards(lastId: Int?, limit: Int, order: String) -> AnyPublisher<BoardListDataDTO, NetworkError> {
    let query: CursorPagingQuery = .init(lastId: lastId, limit: limit, order: order)
    return networkService.request(
      BoardEndpoint.boards(query),
      responseType: SuccessResponse<BoardListDataDTO>.self
    )
    .map(\.data)
    .eraseToAnyPublisher()
  }

  public func fetchBoardsByCategory(category: String, lastId: Int?, limit: Int, order: String) -> AnyPublisher<BoardListDataDTO, NetworkError> {
    let query: CategoryPagingQuery = .init(category: category, cursor: .init(lastId: lastId, limit: limit, order: order))
    return networkService.request(
      BoardEndpoint.boardsByCategory(query),
      responseType: SuccessResponse<BoardListDataDTO>.self
    )
    .map(\.data)
    .eraseToAnyPublisher()
  }

  public func fetchBoardDetail(boardId: Int) -> AnyPublisher<BoardDetailResponseDTO, NetworkError> {
    return networkService.request(
      BoardEndpoint.boardDetail(boardId: boardId),
      responseType: SuccessResponse<BoardDetailResponseDTO>.self
    )
    .map(\.data)
    .eraseToAnyPublisher()
  }

  public func createBoard(
    title: String,
    content: String,
    category: String,
    images: [UIImage]
  ) -> AnyPublisher<BoardResponseDTO, NetworkError> {
    let dto = BoardRequestDTO(
      title: title,
      content: content,
      category: category,
      imageUrls: [] // multipart에서는 사용 안함
    )

    let endpoint = BoardEndpoint.createBoard(dto)

    if images.isEmpty {
      // 이미지 없으면 일반 JSON request
      return networkService.request(endpoint, responseType: SuccessResponse<BoardResponseDTO>.self)
        .map(\.data)
        .eraseToAnyPublisher()
    } else {
      // 이미지 있으면 multipart upload
      return networkService.uploadMultipart(
        endpoint,
        images: images,
        responseType: SuccessResponse<BoardResponseDTO>.self
      )
      .map(\.data)
      .eraseToAnyPublisher()
    }
  }

  // MARK: - Comments
  public func fetchComments(boardId: Int, lastId: Int?, limit: Int, order: String) -> AnyPublisher<CommentListDataDTO, NetworkError> {
    let query: CursorPagingQuery = .init(lastId: lastId, limit: limit, order: order)
    return networkService.request(
      BoardEndpoint.comments(boardId: boardId, query: query),
      responseType: SuccessResponse<CommentListDataDTO>.self
    )
    .map(\.data)
    .eraseToAnyPublisher()
  }

  public func createComment(boardId: Int, content: String) -> AnyPublisher<CommentResponseDTO, NetworkError> {
    return networkService.request(
      BoardEndpoint.createComment(boardId: boardId, content: content),
      responseType: SuccessResponse<CommentResponseDTO>.self
    )
    .map(\.data)
    .eraseToAnyPublisher()
  }

  public func updateComment(boardId: Int, commentId: Int, content: String) -> AnyPublisher<CommentResponseDTO, NetworkError> {
    return networkService.request(
      BoardEndpoint.updateComment(boardId: boardId, commentId: commentId, content: content),
      responseType: SuccessResponse<CommentResponseDTO>.self
    )
    .map(\.data)
    .eraseToAnyPublisher()
  }

  public func deleteComment(boardId: Int, commentId: Int) -> AnyPublisher<Void, NetworkError> {
    return networkService.request(
      BoardEndpoint.deleteComment(boardId: boardId, commentId: commentId),
      responseType: SuccessResponse<Bool>.self
    )
    .map { _ in () }
    .eraseToAnyPublisher()
  }

  // MARK: - Likes
  public func fetchLikeInfo(boardId: Int) -> AnyPublisher<LikeResponseDTO, NetworkError> {
    return networkService.request(
      BoardEndpoint.likeInfo(boardId: boardId),
      responseType: SuccessResponse<LikeResponseDTO>.self
    )
    .map(\.data)
    .eraseToAnyPublisher()
  }

  public func toggleLike(boardId: Int) -> AnyPublisher<LikeResponseDTO, NetworkError> {
    return networkService.request(
      BoardEndpoint.toggleLike(boardId: boardId),
      responseType: SuccessResponse<LikeResponseDTO>.self
    )
    .map(\.data)
    .eraseToAnyPublisher()
  }

  // MARK: - Report
  public func reportContent(request: ReportRequestDTO) -> AnyPublisher<Void, NetworkError> {
    return networkService.request(
      BoardEndpoint.report(request),
      responseType: SuccessResponse<EmptyResponse>.self
    )
    .map { _ in () }
    .eraseToAnyPublisher()
  }
}
