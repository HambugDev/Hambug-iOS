//
//  AppDelegate.swift
//  Hambug
//
//  Created by 강동영 on 1/13/26.
//

import UIKit
import FCMService
import AppDI

class AppDelegate: NSObject, UIApplicationDelegate {
  private let appDIContainer: AppDIContainer = .shared
  lazy var fcmManager: FCMManager = appDIContainer.makeFCMManager()
  private let notificationService = NotificationService.shared
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication
      .LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    fcmManager.configure()
    
    // MARK: APNS 등록
    UNUserNotificationCenter.current().delegate = notificationService
    
    
    Task { @MainActor in
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
      if granted {
        application.registerForRemoteNotifications()
      }
    }
    
    return true
  }
  
  // MARK: - APNS 등록 성공/실패 메서드
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    fcmManager.registAPNsToken(deviceToken)
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
    print("❌ Token 등록에 실패했습니다.")
  }
}
