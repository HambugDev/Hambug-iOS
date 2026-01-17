//
//  AlarmRepository.swift
//  Alarm
//
//  Created by 강동영 on 10/17/25.
//

import Foundation

public protocol AlarmRepository: Sendable {
  func fetchAlarms() async throws -> NotificationListData
}
