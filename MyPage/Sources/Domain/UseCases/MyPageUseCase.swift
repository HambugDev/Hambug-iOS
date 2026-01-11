//
//  MyPageUseCase.swift
//  Hambug
//
//  Created by 강동영 on 11/27/25.
//

import Foundation
import SharedDomain

public protocol MyPageUseCase {
  func fetchProfile()
  
  func updateNickname(_ nickName: String)
  func changeProfileImage()
  func applyDefaultImage()
  
  func logout()
  func deleteAccount()
  func fetchProfile() async throws -> User
}

// MARK: - MyPage UseCase 구현체
public final class MyPageUseCaseImpl: MyPageUseCase {
  private let repository: MyPageRepository
  
  public init(repository: MyPageRepository) {
    self.repository = repository
  }
  
  public func fetchProfile() async throws -> User {
    do {
      return try await repository.fetchProfile()
    } catch {
      throw error
    }
    
  }
  }
  
  public func updateNickname(_ nickName: String) {}
  public func changeProfileImage() {}
  public func applyDefaultImage() {}
  
  public func logout() {}
  public func deleteAccount() {}
}
