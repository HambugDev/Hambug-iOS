//
//  CommunityWriteView.swift
//  Hambug
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI
import DesignSystem

public struct CommunityWriteView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var selectedCategory: Category = .자유잡담
  @State private var title: String = ""
  @State private var content: String = ""
  @State private var characterCount: Int = 0

  private let maxCharacterCount = 300

  public init() {}

  private var isCharacterMax: Bool {
    characterCount >= maxCharacterCount
  }
  enum Category: String, CaseIterable {
    case 자유잡담 = "자유잡담"
    case 프랜차이즈 = "프랜차이즈"
    case 수제버거 = "수제버거"
    case 맛집추천 = "맛집추천"
  }
  
  public var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        navigationBar
        
        ScrollView {
          VStack(alignment: .leading, spacing: 24) {
            categorySelection
            titleSection
            contentSection
            imageAttachmentSection
            
          }
          .padding(.horizontal, 16)
          .padding(.top, 20)
          
          VStack(alignment: .center) {
            addImageButtonSection
          }
          .padding(.horizontal, 16)
          .padding(.top, 20)
        }
        
        Spacer()
        
        PrimaryButton(
          title: "등록",
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
      
      Text("게시물 작성")
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
  
  private var categorySelection: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 0) {
        Text("카테고리")
          .pretendard(.body(.bEmphasis))
          .foregroundColor(.textG900)
        
        Text("*")
          .pretendard(.body(.bEmphasis))
          .foregroundColor(.primaryHambugRed)
      }
      
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
          ForEach(Category.allCases, id: \.self) { category in
            Button {
              selectedCategory = category
            } label: {
              Text(category.rawValue)
                .pretendard(.caption(.emphasis))
                .foregroundColor(selectedCategory == category ? Color.primaryHambugRed : .textG600)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                  RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .stroke(selectedCategory == category ? Color.primaryHambugRed : Color.borderG300, lineWidth: 1.0)
                )
            }
          }
        }
        .padding(.horizontal, 16)
      }
      .padding(.horizontal, -16)
    }
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 0) {
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
  
  private let contentPlaceholder: String = "자유롭게 이야기를 나눠보세요"
  private var contentSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 0) {
        Text("내용")
          .pretendard(.body(.bEmphasis))
          .foregroundColor(.textG900)
        Text("*")
          .pretendard(.body(.bEmphasis))
          .foregroundColor(.primaryHambugRed)
      }
      
      BorderTextEditor(
        maxCharacterCount: maxCharacterCount,
        content: $content
      )
    }
  }
  
  private var imageAttachmentSection: some View {
    HStack(spacing: 8) {
      AddedImageView {}
      AddedImageView {}
      
      Spacer()
    }
  }
  private var addImageButtonSection: some View {
    Button {
      
    } label: {
      Label("사진추가 (2/5)", systemImage: "camera")
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .foregroundColor(Color.primaryHambugRed)
        .background(
          RoundedRectangle(cornerRadius: 0)
            .stroke(Color.primaryHambugRed, lineWidth: 1)
        )
    }
    
    
  }
}

#Preview {
  CommunityWriteView()
}


fileprivate struct CommunityWriteFilterChip: View {
  let category: String
  let isSelected: Bool
  
  var body: some View {
    Text(category)
      .pretendard(.caption(.emphasis))
      .foregroundColor(isSelected ? Color.primaryHambugRed : .textG600)
      .padding(.horizontal, 10)
      .padding(.vertical, 8)
      .background(
        RoundedRectangle(cornerRadius: 2)
          .fill(Color.white)
          .stroke(isSelected ? Color.primaryHambugRed : Color.borderG300, lineWidth: 1.0)
      )
  }
}

struct AddedImageView: View {
  private let action: () -> Void
  var body: some View {
    ZStack(alignment: .topTrailing) {
      // 메인 사각형 영역
      RoundedRectangle(cornerRadius: 8)
        .fill(Color.bgG100)
        .frame(width: 80, height: 80)
      
      // X 버튼 (우측 상단)
      Button(action: {
        action()
      }) {
        Image(systemName: "xmark.circle.fill")
          .foregroundColor(Color.iconG600)
          .frame(width: 20, height: 20)
          .padding(10)
      }
      .offset(x: 18, y: -18) // 사각형 밖으로 살짝 나오게
    }
  }
  
  init(action: @escaping @MainActor () -> Void) {
    self.action = action
  }
}
