//
//  PagingContent.swift
//  Infrastructure
//
//  Created by 강동영 on 1/19/26.
//


public struct PagingContent<T: Decodable & Sendable>: Decodable, Sendable {
  public let content: T
  public let nextCursorId: Int?
  public let nextPage: Bool

  private enum CodingKeys: String, CodingKey {
    case content
    case nextCursorId
    case nextPage
  }
}