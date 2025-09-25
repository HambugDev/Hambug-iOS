//
//  SplashView.swift
//  Hambug
//
//  Created by 강동영 on 9/25/25.
//

import SwiftUI

struct SplashView: View {
    @Environment(AppStateManager.self) var appStateManager
    
    var body: some View {
        ZStack {
            Color(.bgYellow)
                .ignoresSafeArea()
            Image(.splashLogo)
        }
        .task {
            try? await Task.sleep(for: .seconds(1))
            appStateManager.state = .onboarding
        }
    }
}

#Preview {
    SplashView()
}
