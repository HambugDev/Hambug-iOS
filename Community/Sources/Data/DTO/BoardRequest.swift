//
//  BoardRequest.swift
//  Community
//
//  Created by 강동영 on 1/8/26.
//

import Foundation

// MARK: - Report Request DTO
public struct BoardRequestDTO: Encodable, Sendable {
  public let title: String
  public let content: String
  public let category: String
  public let imageUrls: [String]

  public init(
    title: String,
    content: String,
    category: String,
    imageUrls: [String]
  ) {
    self.title = title
    self.content = content
    self.category = category
    self.imageUrls = imageUrls
  }
}
