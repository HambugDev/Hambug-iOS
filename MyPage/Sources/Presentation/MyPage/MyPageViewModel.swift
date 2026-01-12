//
//  MyPageViewModel.swift
//  Hambug
//
//  Created by 강동영 on 10/28/25.
//

import Combine
import Foundation
import Observation
import UIKit
import MyPageDomain
import SharedDomain

@Observable
public final class MyPageViewModel {
  private let usecase: MyPageUseCase
  private var cancellables: Set<AnyCancellable> = []

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
  
  func fetchProfile() {
    isLoading = true
    usecase.fetchProfile()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] user in
        self?.isLoading = false
        self?.user = user
        self?.profileNickName = user.nickname
      }
      .store(in: &cancellables)
  }
  
  func updateNickname() {
    let trimmed = currentNickName.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      isCorrectedNickName = false
      return
    }

    isCorrectedNickName = true
    isLoading = true
    usecase.updateNickname(trimmed)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.isLoading = false
        self?.profileNickName = trimmed
      }
      .store(in: &cancellables)
  }
  
  func changeProfileImage(_ imageData: Data) {
    guard let image = UIImage(data: imageData) else {
      errorMessage = "이미지를 불러올 수 없습니다."
      showError = true
      return
    }

    isLoading = true
    usecase.changeProfileImage(image)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          self?.isLoading = false
          
          switch completion {
          case .failure:
            self?.errorMessage = "이미지 변경에 실패했습니다. 다시 시도해 주세요."
            self?.showError = true
          case .finished:
//            self?.fetchProfile()
            break
          }
        },
        receiveValue: { [weak self] in
          self?.user?.profileImageURL = $0
        }
      )
      .store(in: &cancellables)
  }
  
  func applyDefaultImage() {
    isLoading = true
    usecase.applyDefaultImage()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          self?.isLoading = false
          
          switch completion {
          case .failure:
            self?.errorMessage = "이미지 변경에 실패했습니다. 다시 시도해 주세요."
            self?.showError = true
          case .finished:
//            self?.fetchProfile()
            self?.user?.profileImageURL = ""
          }
        },
        receiveValue: {}
      )
      .store(in: &cancellables)
  }
  
  func logout() {
    isLoading = true
    usecase.logout()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.isLoading = false
        self?.shouldNavigateToLogin = true
      }
      .store(in: &cancellables)
  }

  func deleteAccount() {
    guard let provider = user?.loginType.lowercased(), !provider.isEmpty else { return }

    isLoading = true
    usecase.deleteAccount(provider: provider)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.isLoading = false
        self?.shouldNavigateToLogin = true
      }
      .store(in: &cancellables)
  }
}
