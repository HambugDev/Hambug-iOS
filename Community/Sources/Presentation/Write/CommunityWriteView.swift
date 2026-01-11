//
//  CommunityWriteView.swift
//  Hambug
//
//  Created by 강동영 on 10/18/25.
//

import SwiftUI
import DesignSystem
import PhotosUI
import CommunityDomain
import SharedUI

public struct CommunityWriteView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: CommunityWriteViewModelProtocol
  
  @State private var selectedCategory: BoardCategory = .freeTalk
  @State private var title: String = ""
  @State private var content: String = ""
  @State private var characterCount: Int = 0
  @FocusState private var focusedField: Field?
  
  @State private var photosPickerItems: [PhotosPickerItem] = []

  private let maxCharacterCount: Int

  public init(
    viewModel: CommunityWriteViewModelProtocol,
    title: String = "",
    content: String = "",
    characterCount: Int = 0,
    maxCharacterCount: Int = 300
  ) {
    self.viewModel = viewModel
    
    self.title = title
    self.content = content
    self.characterCount = content.count
    self.maxCharacterCount = maxCharacterCount
  }

  private var isCharacterMax: Bool {
    characterCount >= maxCharacterCount
  }
  
  enum Field: Hashable {
    case title
    case content
  }
  
  public var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        navigationBar

        VStack(spacing: 0) {
          ScrollView {
            VStack(alignment: .leading, spacing: 16) {
              categorySelection
              titleSection
              contentSection
              imageAttachmentSection
            }
            .padding(.top, 20)
            .background(
              Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                  focusedField = nil
                }
            )

            VStack(alignment: .center) {
              addImageButtonSection
            }
            .padding(.top, 20)
          }

          Spacer()

          PrimaryButton(
            title: viewModel.isSubmitting ? "등록 중..." : "등록",
            style: .body(.bEmphasis)
          ) {
            focusedField = nil
            Task {
              let success = await viewModel.writeBoard(
                title: title,
                content: content,
                category: selectedCategory
              )
              if success {
                dismiss()
              }
            }
          }
          .padding(.bottom, 20)
          .disabled(!viewModel.canSubmit)
        }
        .padding(.horizontal, 20)
      }
      .background(Color.bgWhite)
      .alert("이미지 크기 초과", isPresented: $viewModel.showImageSizeAlert) {
        Button("확인", role: .cancel) { }
      } message: {
        Text("이미지 크기가 너무 큽니다. 다른 이미지를 선택해주세요.")
      }
      .tabBarHidden(true)
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
      RequiredText("카테고리")
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
          ForEach(BoardCategory.allCases, id: \.self) { category in
            Button {
              selectedCategory = category
            } label: {
              Text(category.displayName)
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
      }
    }
  }
  
  private var titleSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      RequiredText("제목")

      BottomLineTextField(
        title: $title,
        focusedField: $focusedField,
        field: .title
      )
    }
  }
  
  private let contentPlaceholder: String = "자유롭게 이야기를 나눠보세요"
  private var contentSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      RequiredText("내용")

      BorderTextEditor(
        maxCharacterCount: maxCharacterCount,
        content: $content,
        focusedField: $focusedField,
        field: .content
      )
    }
  }
  
  private var imageAttachmentSection: some View {
    Group {
      if !viewModel.selectedImages.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(viewModel.selectedImages) { selectedImage in
              AddedImageView(
                image: selectedImage.image,
                onDelete: {
                  viewModel.removeImage(id: selectedImage.id)
                }
              )
            }
          }
        }
      }
    }
  }
  
  private var addImageButtonSection: some View {
    PhotosPicker(
      selection: $photosPickerItems,
      maxSelectionCount: viewModel.maxSelectionCount,
      matching: .images
    ) {
      Label(viewModel.imageCountText, systemImage: "camera")
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .foregroundColor(Color.primaryHambugRed)
        .background(
          RoundedRectangle(cornerRadius: 0)
            .stroke(Color.primaryHambugRed, lineWidth: 1)
        )
    }
    .onChange(of: photosPickerItems) { _, newValue in
      Task {
        await viewModel.handleImageSelection(newValue)
        photosPickerItems.removeAll()
      }
    }
    .disabled(!viewModel.canAddMoreImages || viewModel.isProcessingImages)
  }
}

//#Preview {
//  let diContainer = CommunityDI.CommunityDIContainer()
//  CommunityWriteView(viewModel: diContainer.makeCommunityWriteViewModel())
//}


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
  let image: UIImage?
  private let action: () -> Void

  var body: some View {
    ZStack(alignment: .topTrailing) {
      // 이미지 또는 플레이스홀더
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(width: 80, height: 80)
          .clipped()
          .cornerRadius(8)
      } else {
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.bgG100)
          .frame(width: 80, height: 80)
      }

      // X 버튼 (우측 상단)
      Button(action: {
        action()
      }) {
        Image(systemName: "xmark.circle.fill")
          .foregroundColor(Color.iconG600)
          .frame(width: 20, height: 20)
          .padding(10)
      }
      .offset(x: 20, y: -20)
    }
    .padding(.top, 8)
    .padding(.trailing, 8)
  }

  init(image: UIImage? = nil, onDelete action: @escaping @MainActor () -> Void) {
    self.image = image
    self.action = action
  }
}
