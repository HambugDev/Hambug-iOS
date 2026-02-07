//
//  MyPageUseCase.swift
//  Hambug
//
//  Created by 강동영 on 11/27/25.
//

import Foundation
import UIKit
import SharedDomain

public protocol MyPageUseCase: Sendable {
  func fetchProfile() async throws -> User

  func updateNickname(_ nickName: String) async
  func changeProfileImage(_ image: UIImage?) async throws -> String
  func applyDefaultImage() async

  func logout() async
  func deleteAccount(provider: String) async
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
  
  public func updateNickname(_ nickName: String) async {
    await repository.updateNickname(nickName)
  }
  
  public func changeProfileImage(_ image: UIImage?) async throws -> String {
    try await repository.changeProfileImage(image)
  }
  
  public func applyDefaultImage() async {
    do {
      try await repository.applyDefaultImage()
    } catch {
      print(error.localizedDescription)
    }
    
  }
  
  public func logout() async {
    await repository.logout()
  }
  
  public func deleteAccount(provider: String) async {
    await repository.deleteAccount(provider: provider)
  }
}
