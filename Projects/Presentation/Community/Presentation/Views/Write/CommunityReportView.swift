//
//  CommunityReportView.swift
//  Hambug
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI
import DesignSystem

struct CommunityReportView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var title: String = ""
  @State private var content: String = ""
  @State private var characterCount: Int = 0
  
  private let maxCharacterCount = 2000
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        navigationBar
        
        ScrollView {
          VStack(alignment: .leading, spacing: 24) {
            titleSection
            contentSection
          }
          .padding(.horizontal, 16)
          .padding(.top, 20)
        }
        
        Spacer()
        
        PrimaryButton(
          title: "신고 등록",
          style: .body(.bEmphasis)
        ) {
          // Handle submit action
        }
      }
      .background(Color.bgWhite)
    }
    .navigationBarHidden(true)
  }
  
  private var navigationBar: some View {
    HStack {
      Button {
        dismiss()
      } label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(.iconG800)
      }
      
      Spacer()
      
      Text("신고")
        .pretendard(.title(.t2))
        .foregroundColor(.textG900)
      
      Spacer()
      
      Color.clear
        .frame(width: 18, height: 18)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.bgWhite)
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("제목")
          .pretendard(.body(.bEmphasis))
          .foregroundColor(.textG900)
        Text("*")
          .pretendard(.body(.bEmphasis))
          .foregroundColor(.primaryHambugRed)
      }
      
      BottomLineTextField(title: $title)
    }
  }
  
  private var contentSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("내용")
          .pretendard(.body(.bEmphasis))
          .foregroundColor(.textG900)
        Text("*")
          .pretendard(.body(.bEmphasis))
          .foregroundColor(.primaryHambugRed)
      }
      
      ZStack(alignment: .topLeading) {
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.borderG300, lineWidth: 1)
          .background(Color.bgWhite)
          .frame(height: 200)
        
        if content.isEmpty {
          Text("내용을 입력해주세요.")
            .pretendard(.body(.base))
            .foregroundColor(.textG600)
            .padding(.horizontal, 16)
            .padding(.top, 14)
        }
        
        BorderTextEditor(maxCharacterCount: 10, content: $content)
      }
    }
  }
}

#Preview {
  CommunityReportView()
}
