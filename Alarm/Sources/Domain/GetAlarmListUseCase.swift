//
//  GetAlarmListUseCase.swift
//  Alarm
//
//  Created by 강동영 on 1/16/26.
//


public protocol GetAlarmListUseCase: Sendable {
  func execute() async throws -> NotificationListData
}

public final class GetAlarmListUseCaseImpl: GetAlarmListUseCase {

  private let repository: AlarmRepository

  public init(repository: AlarmRepository) {
    self.repository = repository
  }

  public func execute() async throws -> NotificationListData {
    return try await repository.fetchAlarms()
  }
}
