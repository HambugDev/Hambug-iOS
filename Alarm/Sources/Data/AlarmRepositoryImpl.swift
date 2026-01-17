//
//  AlarmRepositoryImpl.swift
//  Alarm
//
//  Created by 강동영 on 1/17/26.
//

import AlarmDomain
import NetworkInterface
import Util

public final class AlarmRepositoryImpl: AlarmRepository {
  private let networkService: NetworkServiceInterface
  
  public init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }
  
  public func fetchAlarms() async throws -> NotificationListData {
    return try await networkService.request(
      AlarmEndpoint(),
      responseType: SuccessResponse<NotificationListDataDTO>.self
    )
    .map(\.data)
    .map { $0.toDomain() }
    .async()
  }
}
