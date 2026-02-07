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
  public let hasImage: Bool


  private enum CodingKeys: String, CodingKey {
    case title, content, category
  }

  public init(
    title: String,
    content: String,
    category: String,
    hasImage: Bool
  ) {
    self.title = title
    self.content = content
    self.category = category
    self.hasImage = hasImage
  }
}
