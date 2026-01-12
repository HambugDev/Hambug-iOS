//
//  MyPageViewModel.swift
//  Hambug
//
//  Created by 강동영 on 10/28/25.
//

import Foundation
import Observation
import UIKit
import MyPageDomain
import SharedDomain

@Observable
public final class MyPageViewModel {
  private let usecase: MyPageUseCase

  var currentNickName: String = ""
  var profileNickName: String = ""
  var isCorrectedNickName: Bool = true
  var user: User?

  var isLoading: Bool = false
  var errorMessage: String?
  var showError: Bool = false
  var shouldNavigateToLogin: Bool = false
  var showImageSizeAlert: Bool = false

  public init(usecase: MyPageUseCase) {
    self.usecase = usecase
  }
  
  func fetchProfile() async {
    isLoading = true
    do {
      let response = try await usecase.fetchProfile()
      isLoading = false
      user = user
      profileNickName = response.nickname
    } catch {
      
    }
  }
  
  func updateNickname() async {
    let trimmed = currentNickName.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      isCorrectedNickName = false
      return
    }

    isCorrectedNickName = true
    isLoading = true
    
    await usecase.updateNickname(trimmed)
    isLoading = false
    profileNickName = trimmed
  }
  
  func changeProfileImage(_ imageData: Data) async {
    guard let image = UIImage(data: imageData) else {
      errorMessage = "이미지를 불러올 수 없습니다."
      showError = true
      return
    }

    isLoading = true
    
    do {
      let profileURL = try await usecase.changeProfileImage(image)
      user?.profileImageURL = profileURL
    } catch {
      errorMessage = "이미지 변경에 실패했습니다. 다시 시도해 주세요."
      showError = true
    }
    
    isLoading = false
  }
  
  func applyDefaultImage() async {
    isLoading = true
    await usecase.applyDefaultImage()
    isLoading = false
    user?.profileImageURL = ""
  }
  
  func logout() async {
    isLoading = true
    await usecase.logout()
    
    isLoading = false
    shouldNavigateToLogin = true
  }

  func deleteAccount() async {
    guard let provider = user?.loginType.lowercased(), !provider.isEmpty else { return }

    isLoading = true
    await usecase.deleteAccount(provider: provider)
    isLoading = false
    shouldNavigateToLogin = true
  }
}
