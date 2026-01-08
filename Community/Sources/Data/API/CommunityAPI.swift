//
//  CommunityAPI.swift
//  Hambug
//
//  Created by 강동영 on 10/17/25.
//

import Foundation
import NetworkInterface
import CommunityDomain

// MARK: - Board Endpoints
public enum BoardEndpoint: Endpoint {
  case createBoard(BoardRequestDTO)
  case boards(CursorPagingQuery)
  case boardsByCategory(CategoryPagingQuery)
  case boardDetail(boardId: Int)
  case comments(boardId: Int, query: CursorPagingQuery)
  case createComment(boardId: Int, content: String)
  case updateComment(boardId: Int, commentId: Int, content: String)
  case deleteComment(boardId: Int, commentId: Int)
  case likeInfo(boardId: Int)
  case toggleLike(boardId: Int)
  case report(ReportRequestDTO)

  public var baseURL: String {
    return NetworkConfig.baseURL + "/api/v1"
  }

  public var path: String {
    switch self {
    case .createBoard(let dto):
      return dto.imageUrls.isEmpty ? "/boards" : "/boards/with-image"
    case .boards:
      return "/boards"
    case .boardsByCategory:
      return "/boards/category"
    case .boardDetail(let boardId):
      return "/boards/\(boardId)"
    case .comments(let boardId, _):
      return "/boards/\(boardId)/comments"
    case .createComment(let boardId, _):
      return "/boards/\(boardId)/comments"
    case .updateComment(let boardId, let commentId, _):
      return "/boards/\(boardId)/comments/\(commentId)"
    case .deleteComment(let boardId, let commentId):
      return "/boards/\(boardId)/comments/\(commentId)"
    case .likeInfo(let boardId):
      return "/boards/\(boardId)/likes"
    case .toggleLike(let boardId):
      return "/boards/\(boardId)/likes"
    case .report:
      return "/reports"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .boards, .boardsByCategory, .boardDetail, .comments, .likeInfo:
      return .GET
    case .createBoard, .createComment, .toggleLike, .report:
      return .POST
    case .updateComment:
      return .PUT
    case .deleteComment:
      return .DELETE
    }
  }

  public var headers: [String: String] {
    return [:]
  }

  public var queryParameters: [String: Any] {
    switch self {
    case let .boards(dto):
      return queryEncoder.encode(dto)
    case let .boardsByCategory(dto):
      return queryEncoder.encode(dto)
    case let .comments(_, dto):
      return queryEncoder.encode(dto)
    default:
      return [:]
    }
  }

  public var body: Data? {
    let encoder = JSONEncoder()
    switch self {
    case .createBoard(let dto):
      return try? encoder.encode(dto)
    case .createComment(_, let content):
      let body = ["content": content]
      return try? encoder.encode(body)
    case .updateComment(_, _, let content):
      let body = ["content": content]
      return try? encoder.encode(body)
    case .report(let request):
      return try? encoder.encode(request)
    default:
      return nil
    }
  }
}
