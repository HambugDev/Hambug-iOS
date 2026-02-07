//
//  Report.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation

// MARK: - Report Target Type
public enum ReportTargetType: String, Codable, Sendable {
  case board = "BOARD"
  case comment = "COMMENT"
}

// MARK: - Report Request
public struct ReportRequest: Sendable {
  public let targetId: Int
  public let targetType: ReportTargetType
  public let reason: String

  public init(targetId: Int, targetType: ReportTargetType, reason: String) {
    self.targetId = targetId
    self.targetType = targetType
    self.reason = reason
  }
}
