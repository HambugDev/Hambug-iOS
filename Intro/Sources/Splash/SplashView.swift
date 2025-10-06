//
//  SplashView.swift
//  Hambug
//
//  Created by 강동영 on 9/25/25.
//

import SwiftUI
import DesignSystem
import Managers

@available(iOS, introduced: 17.0)
public struct SplashView: View {
    @Environment(AppStateManager.self) var appStateManager
    
    public var body: some View {
        ZStack {
            Color.bgYellow
                .ignoresSafeArea()
            Image(.splashLogo)
        }
        .task {
            try? await Task.sleep(for: .seconds(1))
            appStateManager.completeSplash()
        }
    }
    
    public init() {}
}

@available(iOS, introduced: 17.0)
#Preview {
    let appStateManager = AppStateManager()
    SplashView()
        .environment(appStateManager)
}
