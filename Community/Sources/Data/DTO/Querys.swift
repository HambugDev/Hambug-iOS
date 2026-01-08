//
//  Querys.swift
//  Community
//
//  Created by 강동영 on 1/9/26.
//

import Foundation


/// 재사용 되는 페이지네이션 쿼리
public struct CursorPagingQuery: Encodable, Sendable {
  let lastId: Int?
  let limit: Int
  let order: String
}

/// CategoryPagingQuery
public struct CategoryPagingQuery: Encodable, Sendable {
  let category: String
  let cursor: CursorPagingQuery
  
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(category, forKey: .category)
    try container.encodeIfPresent(cursor.lastId, forKey: .lastId)
    try container.encode(cursor.limit, forKey: .limit)
    try container.encode(cursor.order, forKey: .order)
  }
  
  enum CodingKeys: String, CodingKey {
    case category, lastId, limit, order
  }
}
