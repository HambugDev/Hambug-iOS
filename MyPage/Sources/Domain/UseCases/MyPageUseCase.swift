//
//  MyPageUseCase.swift
//  Hambug
//
//  Created by 강동영 on 11/27/25.
//

import Foundation

public protocol MyPageUseCase {
  func fetchProfile()
  
  func updateNickname(_ nickName: String)
  func changeProfileImage()
  func applyDefaultImage()
  
  func logout()
  func deleteAccount()
}

// MARK: - MyPage UseCase 구현체
public final class MyPageUseCaseImpl: MyPageUseCase {
  private let repository: MyPageRepository
  
  public init(repository: MyPageRepository) {
    self.repository = repository
  }
  
  public func fetchProfile() {
    repository.fetchProfile(userId: 0)
  }
  
  public func updateNickname(_ nickName: String) {}
  public func changeProfileImage() {}
  public func applyDefaultImage() {}
  
  public func logout() {}
  public func deleteAccount() {}
}
