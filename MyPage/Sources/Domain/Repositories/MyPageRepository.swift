//
//  MyPageRepositoryInterface.swift
//  Hambug
//
//  Created by 강동영 on 10/30/25.
//

import Foundation
import Combine
import UIKit
import SharedDomain

// MARK: - MyPage Repository Interface
public protocol MyPageRepository {
  typealias ProfileURL = String
  func fetchProfile() async throws -> User

  func updateNickname(_ nickName: String) async
  func changeProfileImage(_ image: UIImage?) async throws -> ProfileURL
  func applyDefaultImage() async throws

  func logout() async
  func deleteAccount(provider: String) async
}
