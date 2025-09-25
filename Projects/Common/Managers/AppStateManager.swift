//
//  AppState.swift
//  Hambug
//
//  Created by 강동영 on 9/26/25.
//

import Foundation

enum AppState: Equatable {
    case splash
    case main
}

@Observable
class AppStateManager {
    var state: AppState = .splash
}
