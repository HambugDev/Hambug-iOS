//
//  FCMManager.swift
//  3rdParty
//
//  Created by 강동영 on 1/13/26.
//

import Combine
import Foundation

import NetworkInterface
import DataSources
import Util

import FirebaseCore
import FirebaseMessaging


public final class FCMManager: NSObject, @unchecked Sendable {
  private let service: NetworkServiceInterface
  private let storage: FCMTokenStorageable
  
  public init(
    service: NetworkServiceInterface,
    storage: FCMTokenStorageable
  ) {
    self.service = service
    self.storage = storage
  }
  
  public func configure() {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
  }
  
  public func registAPNsToken(_ deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0)}.joined()
    print("device Token: \(token)")
    Messaging.messaging().apnsToken = deviceToken
  }
  
  public func sendPendingTokenToServer() async {
    if let fcmToken = storage.load() {
      await sendTokenToServer(fcmToken)
    }
  }
  
  private func sendTokenToServer(_ fcmToken: String) async {
    let endpoint = FCMEndpoint(body: FCMRequest(token: fcmToken))
    
    do {
      let isSuccess = try await service.request(
        endpoint,
        responseType: SuccessResponse<Bool>.self
      ).async()
      
      print("FCM Token Send to Server Success: \(isSuccess)")
    } catch {
      print("FCM Token Send to Server Failed")
      print("errorMessage: \(error.localizedDescription)")
    }
  }
}

extension FCMManager: MessagingDelegate {
  
  // MARK: - 등록 토큰을 제공하는 메서드
  // 호출 되는 시점: FCM SDK는 최초 앱 시작 시
  //
  // 토큰 업데이트 혹은 무효화될 때마다,
  // 신규 또는 기존 토큰을 가져옴
  
  // 등록 토큰 변경시점:
  //
  // 새 기기에서 앱 복원
  // 사용자가 앱 제거/재설치
  // 사용자가 앱 데이터 삭제
  public func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    guard let fcmToken = fcmToken else { return }
    print("fcmToken: \(fcmToken)")
    
    let storedToken = storage.load()
    // 기존 토큰 확인 및 fcm 토큰 변경여부 확인
    if let storedToken = storedToken, storedToken == fcmToken {
      print("✅ FCM Token unchanged")
      return
    }
    
    // 저장 된 토큰이 없거나, 기존 토큰과 다른 경우 저장만
    // 로그인 정보가 없어서, 403떨어짐
    try? storage.save(fcmToken)
  }
}
