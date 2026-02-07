//
//  OnboardingViewModel.swift
//  Intro
//
//  Created by 강동영 on 12/18/25.
//

import Observation
import Managers

@Observable
public class OnboardingViewModel {
  private let appStateManager: AppStateManager
  private let steps: [OnboardingStep] = .onboardingSteps
  var currentStep: Int = 0
  
  var curretnStepData: OnboardingStep {
    steps[currentStep]
  }
  
  public init(appStateManager: AppStateManager) {
    self.appStateManager = appStateManager
  }
  
  func tappedNextButton() {
    if currentStep < steps.count - 1 {
      currentStep += 1
    } else {
      appStateManager.completeOnboarding()
    }
  }
}

struct OnboardingStep {
  let title: String
  let highlightedText: String
  let subTitle: String
  let step: Int
}

extension [OnboardingStep] {
  static let onboardingSteps: [OnboardingStep] = [
    .init(
      title: "전국의 맛있는\n",
      highlightedText: "햄버거 맛집",
      subTitle: "을 공유해요.",
      step: 0
    ),
    .init(
      title: "매일매일\n",
      highlightedText: "오늘의 햄버거",
      subTitle: "를 추천받아요.",
      step: 1
    ),
    .init(
      title: "",
      highlightedText: "햄버거에 빠진 사람들",
      subTitle: "과\n정보를 공유하고 소통해요.",
      step: 2
    ),
  ]
}
