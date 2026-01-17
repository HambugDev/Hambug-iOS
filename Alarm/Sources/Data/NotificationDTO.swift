//
//  NotificationDTO.swift
//  Alarm
//
//  Created by 강동영 on 1/16/26.
//

import Foundation
import AlarmDomain

public struct NotificationListDataDTO: Decodable, Sendable {
  public let content: [NotificationResponseDTO]
  public let lastId: Int?
  public let hasNext: Bool

  private enum CodingKeys: String, CodingKey {
    case content
    case lastId
    case hasNext
  }
}

extension NotificationListDataDTO {
  func toDomain() -> NotificationListData {
    return NotificationListData(
      content: content.map { $0.toDomain()},
      lastId: lastId,
      hasNext: hasNext
    )
  }
}

public struct NotificationResponseDTO: Decodable, Sendable {
  let id: Int64
  let title: String
  let content: String
  let type: NotificationType
  let targetId: Int64
  let thumbnailUrl: String?
  let isRead: Bool
  let createdAt: String
  
  func toDomain() -> AlarmPayload {
    let dateFormatter = DateFormatter.iso8601WithMicroseconds
    
    return .init(
      id: id,
      date: Self.timeAgoDisplay(dateFormatter.date(from: createdAt) ?? Date()),
      content: "\(title)이 \(content)",
      imageUrl: thumbnailUrl
    )
  }
  
  private static func timeAgoDisplay(_ date: Date) -> String {
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

enum NotificationType: String, Decodable {
  case login = "LOGIN_COMPLETE"
  case comment = "COMMENT_NOTIFICATION"
  case like = "LIKE_NOTIFICATION"
}
