//
//  AlarmListViewModel.swift
//  Alarm
//
//  Created by 강동영 on 1/18/26.
//

import Observation
import AlarmDomain

@Observable
public class AlarmListViewModel {
  private let usecase: GetAlarmListUseCase
  var palyload: [AlarmPayload] = []
  
  public init(usecase: GetAlarmListUseCase) {
    self.usecase = usecase
  }
  
  func fetchAlarmList() async {
    do {
      palyload = try await usecase.execute().content
      
    } catch {
      print(error)
    }
  }
}
