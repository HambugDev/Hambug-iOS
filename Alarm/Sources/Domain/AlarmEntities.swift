//
//  AlarmEntities.swift
//  Alarm
//
//  Created by 강동영 on 1/16/26.
//

import Foundation

public struct AlarmPayload: Identifiable, Sendable {
  public let id: Int64
  public let date: String
  public let content: String
  public let imageUrl: String?
  
  public init(
    id: Int64,
    date: String,
    content: String,
    imageUrl: String?
  ) {
    self.id = id
    self.date = date
    self.content = content
    self.imageUrl = imageUrl
  }
}

extension [AlarmPayload] {
  static let dummy: [AlarmPayload] = (1...50).map {
    AlarmPayload(
      id: $0,
      date: "2026.01.1\($0)",
      content: "안녕하세요\($0)",
      imageUrl: nil
    )
  }
}

public struct NotificationListData: Sendable {
  public let content: [AlarmPayload]
  public let lastId: Int?
  public let hasNext: Bool

  private enum CodingKeys: String, CodingKey {
    case content
    case lastId
    case hasNext
  }
  
  public init(content: [AlarmPayload], lastId: Int?, hasNext: Bool) {
    self.content = content
    self.lastId = lastId
    self.hasNext = hasNext
  }
}
