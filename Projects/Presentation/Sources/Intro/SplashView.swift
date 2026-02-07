//
//  SplashView.swift
//  Hambug
//
//  Created by 강동영 on 9/25/25.
//

import SwiftUI
import DesignSystem

@available(iOS, introduced: 17.0)
public struct SplashView: View {
  private let viewModel: SplashViewModel
  public var body: some View {
    ZStack {
      Color.bgYellow
        .ignoresSafeArea()
      Image(.splashLogo)
    }
    .task {
      try? await Task.sleep(for: .seconds(1))
      viewModel.completeSplash()
    }
  }
  
  public init(viewModel: SplashViewModel) {
    self.viewModel = viewModel
  }
}
