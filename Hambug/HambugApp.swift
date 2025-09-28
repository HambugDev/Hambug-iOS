//
//  HambugApp.swift
//  Hambug
//
//  Created by 차상진 on 8/1/25.
//

import SwiftUI

// iOS SDK
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct HambugApp: App {
    @State private var appStateManager: AppStateManager = .init()
    
    init() {
        if let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String {
            print("NATIVE_APP_KEY: ", key)
            KakaoSDK.initSDK(appKey: key)
        } else {
            print("NATIVE_APP_KEY 에러")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appStateManager)
                .onOpenURL { url in
                   if AuthApi.isKakaoTalkLoginUrl(url) {
                       _ = AuthController.handleOpenUrl(url: url)
                   }
                }
        }
        
    }
}

fileprivate struct RootView: View {
    @Environment(AppStateManager.self) var appStateManager
    
    var body: some View {
        Group {
            switch appStateManager.state {
            case .splash:
                SplashView()
                
            case .onboarding:
                OnboardingView()
                
            case .login:
                LoginView()
                
            case .main:
                ContentView()
            }
        }
        .environment(appStateManager)
    }
}

