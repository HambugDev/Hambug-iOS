//
//  NotificationService.swift
//  Hambug
//
//  Created by 강동영 on 1/13/26.
//

import UserNotifications

@MainActor
final class NotificationService: NSObject, Sendable {
  static let shared = NotificationService()
  private override init() {}
}

extension NotificationService: UNUserNotificationCenterDelegate {
  nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
    let userInfo = notification.request.content.userInfo

    print("userInfo: \(userInfo)")

    return [.list, .banner, .sound]
  }

  nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
    let userInfo = response.notification.request.content.userInfo

    print("userInfo: \(userInfo)")
  }
}
