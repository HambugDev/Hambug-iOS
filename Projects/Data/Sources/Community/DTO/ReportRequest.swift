//
//  ReportRequest.swift
//  Hambug
//
//  Created by 강동영 on 01/07/26.
//

import Foundation
import CommunityDomain

// MARK: - Report Request DTO
public struct ReportRequestDTO: Encodable, Sendable {
  public let targetId: Int
  public let targetType: String // BOARD, COMMENT
  public let reason: String

  public init(targetId: Int, targetType: String, reason: String) {
    self.targetId = targetId
    self.targetType = targetType
    self.reason = reason
  }

  private enum CodingKeys: String, CodingKey {
    case targetId
    case targetType
    case reason
  }
}

// MARK: - Domain to DTO Mapper
extension ReportRequestDTO {
  public init(from domain: CommunityDomain.ReportRequest) {
    self.targetId = domain.targetId
    self.targetType = domain.targetType.rawValue
    self.reason = domain.reason
  }
}
