//
//  CommunityReportView.swift
//  Hambug
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI
import DesignSystem
  
public struct CommunityReportView: View {
  @State var viewModel: CommunityReportViewModel
  @Environment(\.dismiss) private var dismiss
  @FocusState private var focusedField: Field?

  enum Field: Hashable {
    case title
    case content
  }

  public init(viewModel: CommunityReportViewModel) {
    self._viewModel = State(initialValue: viewModel)
  }

  public var body: some View {
    VStack(spacing: 0) {
      navigationBar
      
      VStack(spacing: 0) {
        ScrollView {
          VStack(alignment: .leading, spacing: 24) {
            titleSection
            contentSection
          }
          .padding(.top, 20)
          .background(
            Color.clear
              .contentShape(Rectangle())
              .onTapGesture {
                focusedField = nil
              }
          )
        }
        
        Spacer()
        
        PrimaryButton(
          title: "신고 등록",
          style: .body(.bEmphasis)
        ) {
          focusedField = nil
          // Handle submit action
        }
        .padding(.bottom, 20)
        .disabled(!viewModel.canSubmit)
      }
      .padding(.horizontal, 18)
    }
    .background(Color.bgWhite)
    .toolbar(.hidden, for: .navigationBar)
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
      RequiredText("제목")

      BottomLineTextField(
        title: $viewModel.title,
        focusedField: $focusedField,
        field: .title
      )
    }
  }
  
  private var contentSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      RequiredText("내용")

      BorderTextEditor(
        maxCharacterCount: viewModel.maxCharacterCount,
        content: $viewModel.content,
        focusedField: $focusedField,
        field: .content
      )
    }
  }
}

//#Preview {
//  CommunityReportView(viewModel: CommunityReportViewModel())
//}
