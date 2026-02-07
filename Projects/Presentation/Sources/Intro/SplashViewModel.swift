//
//  SplashViewModel.swift
//  Intro
//
//  Created by 강동영 on 12/18/25.
//

import Observation
import Managers

@Observable
public class SplashViewModel {
  private let appStateManager: AppStateManager
  
  public init(appStateManager: AppStateManager) {
    self.appStateManager = appStateManager
  }
  
  func completeSplash() {
    appStateManager.completeSplash()
  }
}
