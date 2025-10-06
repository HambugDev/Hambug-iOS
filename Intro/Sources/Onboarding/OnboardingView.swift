//
//  OnboardingView.swift
//  Hambug
//
//  Created by 강동영 on 9/25/25.
//

import SwiftUI
import DesignSystem
import Managers

@available(iOS, introduced: 17.0)
public struct OnboardingView: View {
    @Environment(AppStateManager.self) var appStateManager
    @State private var currentStep: Int = 0
    
    private let steps: [OnboardingStep] = OnboardingStep.onboardingSteps
    
    public var body: some View {
        ZStack {
            Color(.yellow)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                VStack {
                    Text(buildAttributedString())
//                        .pretendard(.heading(.h2))
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
                
//                PrimaryButton(
//                    title: "다음",
//                    style: .title(.t2)
//                ) {
//                    if currentStep < steps.count - 1 {
//                        currentStep += 1
//                    } else {
//                        appStateManager.completeOnboarding()
//                    }
//                }
            }
            
            
        }
    }
    
    public init() {}
    
    private func buildAttributedString() -> AttributedString {
        let currentData = steps[currentStep]
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

fileprivate struct OnboardingStep {
    let title: String
    let highlightedText: String
    let subTitle: String
    let step: Int
    
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

@available(iOS, introduced: 17.0)
#Preview {
    let appStateManager: AppStateManager = .init()
    OnboardingView()
        .environment(appStateManager)
}
