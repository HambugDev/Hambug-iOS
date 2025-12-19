//
//  MyPageViewModel.swift
//  Hambug
//
//  Created by 강동영 on 10/28/25.
//

import Combine
import MyPageDomain

public final class MyPageViewModel: ObservableObject {
  private let usecase: MyPageUseCase
  
  public init(usecase: MyPageUseCase) {
    self.usecase = usecase
  }
  
  func fetchProfile() {
    
  }
  
  func updateNickname(_ nickName: String) {}
  func changeProfileImage() {}
  func applyDefaultImage() {}
  
  func logout() {}
  func deleteAccount() {}
}
