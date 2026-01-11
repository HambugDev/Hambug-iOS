//
//  HambugCommonAlertView.swift
//  Common
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI

public struct HambugCommonAlertView<Content: View>: View {
  @Binding var isPresented: Bool
  
  private let icon: Image
  @ViewBuilder private let content: Content
  private let secondaryButton: AlertButton?
  private let primaryButton: AlertButton
  
  // 기본 로고가 아닌 커스텀 이미지 사용시 init 하나 더 만들어야합니다.
  public init(
    isPresented: Binding<Bool>,
    @ViewBuilder content: () -> Content,
    secondaryButton: AlertButton?,
    primaryButton: AlertButton
  ) {
    self._isPresented = isPresented
    self.icon = Image(.hambugLogo)
    self.content = content()
    self.secondaryButton = secondaryButton
    self.primaryButton = primaryButton
  }
  
  public var body: some View {
    ZStack {
      Color.black.opacity(0.4)
        .ignoresSafeArea()
        .onTapGesture {
          isPresented = false
          secondaryButton?.action()
        }
      
      VStack(spacing: 0) {
        VStack(spacing: 0) {
          iconSection
          content
        }
        .padding(.horizontal, 10)
        buttonSection
      }
      .frame(maxWidth: 300)
      .background(Color.bgWhite)
      .cornerRadius(16)
      .scaleEffect(isPresented ? 1.0 : 0.8)
      .opacity(isPresented ? 1.0 : 0.0)
      .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPresented)
    }
  }
  
  private var iconSection: some View {
    ZStack {
      icon
        .frame(width: 60, height: 60)
    }
    .padding(.top, 35)
    .padding(.bottom, 14)
  }
  
  private var buttonSection: some View {
    HStack(spacing: 5) {
      if let secondaryButton {
        PrimaryButton(
          title: secondaryButton.title,
          style: .body(.bEmphasis)
        ) {
          isPresented = false
          secondaryButton.action()
        }
        .backgroundColor(.bgG200)
        .foregroundColor(.textG800)
        .cornerRadius(13)
      }
      
      
      PrimaryButton(
        title: primaryButton.title,
        style: .body(.bEmphasis)
      ) {
        isPresented = false
        primaryButton.action()
      }
    }
    .frame(maxHeight: 40)
    .padding(.horizontal, secondaryButton == nil ? 82 : 12)
    .padding(.top, 24)
    .padding(.bottom, 20)
  }
}

public struct AlertButton {
  let title: String
  let action: @MainActor () -> Void
  
  public init(
    title: String,
    action: @escaping @MainActor () -> Void
  ) {
    self.title = title
    self.action = action
  }
  
  public init(
    _ type: AlertButtonType,
    action: @escaping @MainActor () -> Void
  ) {
    self.title = type.title
    self.action = action
  }
  
  public enum AlertButtonType {
    case ok
    case cancel
    case save
    case accountDelete
    
    var title: String {
      switch self {
      case .ok:
        return "확인"
      case .cancel:
        return "취소"
      case .save:
        return "저장"
      case .accountDelete:
        return "탈퇴"
      }
    }
  }
}

#Preview {
  
  HambugCommonAlertView(
    isPresented: .constant(true),
    content: {
      
      VStack(spacing: 10) {
        Text("게시물을 삭제하시겠어여 ?")
          .pretendard(.title(.t2))
          .foregroundStyle(Color.textG900)
        
        Text("회원탈퇴 후 계정 복구가 불가능하며,  작성한 게시글과 댓글은 유지됩니다. 탈퇴하시겠습니까?")
          .pretendard(.body(.small))
          .foregroundStyle(Color.textG600)
          .multilineTextAlignment(.center)
        
      }
      .padding(.top, 16)
      
    },
    secondaryButton: nil,
    //    secondaryButton: AlertButton(title: "취소") {
    //      print("취소")
    //    },
    primaryButton: AlertButton(title: "삭제") {
      print("삭제")
    }
  )
}
