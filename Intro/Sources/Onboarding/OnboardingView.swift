//
//  OnboardingView.swift
//  Hambug
//
//  Created by 강동영 on 9/25/25.
//

import SwiftUI
import DesignSystem

@available(iOS, introduced: 17.0)
public struct OnboardingView: View {
  private let viewModel: OnboardingViewModel
  
  var currentStep: Int {
    viewModel.currentStep
  }
  
  public var body: some View {
    ZStack {
      Color.bgYellow
        .ignoresSafeArea()
      VStack {
        Spacer()
        
        VStack {
          Text(buildAttributedString(from: viewModel.curretnStepData))
            .pretendard(.heading(.h2))
            .multilineTextAlignment(.center)
        }
        
        Spacer()
          .frame(height: 40)
        
        HStack(spacing: 8) {
          ForEach(0..<3) { index in
            PageIndicatorBar(
              isActive: index == currentStep,
              width: getBarWidth(for: index)
            )
          }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
        
        
        Spacer()
          .frame(height: 40)
        
        PrimaryButton(
          title: "다음",
          style: .title(.t2)
        ) {
          viewModel.tappedNextButton()
        }
        .padding(18)
      }
      
      
    }
  }
  
  public init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
  }
  
  func buildAttributedString(from step: OnboardingStep) -> AttributedString {
    let currentData = step
    let fullText = currentData.title + currentData.highlightedText + currentData.subTitle
    
    var attributedString = AttributedString(fullText)
    
    // 기본 텍스트 색상
    attributedString.foregroundColor = .black
    
    // 강조 텍스트 색상 적용
    if !currentData.highlightedText.isEmpty,
       let range = attributedString.range(of: currentData.highlightedText) {
      attributedString[range].foregroundColor = Color.red
    }
    
    return attributedString
  }
  
  private func getBarWidth(for index: Int) -> CGFloat {
    if currentStep == index {
      return 30
    } else {
      return 12
    }
  }
}

fileprivate struct PageIndicatorBar: View {
  let isActive: Bool
  let width: CGFloat
  
  var body: some View {
    RoundedRectangle(cornerRadius: 2)
      .fill(isActive ? Color.red : Color.gray.opacity(0.3))
      .frame(width: width, height: 4)
      .animation(.easeInOut(duration: 0.3), value: width)
      .animation(.easeInOut(duration: 0.3), value: isActive)
  }
}
