//
//  CursorPagingQuery.swift
//  Infrastructure
//
//  Created by 강동영 on 1/12/26.
//


/// 재사용 되는 페이지네이션 쿼리
public struct CursorPagingQuery: Encodable, Sendable {
  public let lastId: Int?
  public let limit: Int
  public let order: String?
  
  public init(
    lastId: Int? = nil,
    limit: Int = 20,
    order: String? = nil
  ) {
    self.lastId = lastId
    self.limit = limit
    self.order = order
  }
}
