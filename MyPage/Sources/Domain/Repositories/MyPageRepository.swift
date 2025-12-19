//
//  MyPageRepositoryInterface.swift
//  Hambug
//
//  Created by 강동영 on 10/30/25.
//

import Foundation
import Combine

// MARK: - MyPage Repository Interface
public protocol MyPageRepository {
  func fetchProfile(userId: Int) -> AnyPublisher<User, Never>
  
  func updateNickname(_ nickName: String)
  func changeProfileImage()
  func applyDefaultImage()
  
  func logout()
  func deleteAccount()
}
