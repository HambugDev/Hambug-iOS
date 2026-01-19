//
//  CommunityWriteViewModel.swift
//  Community
//
//  Created by 강동영 on 1/8/26.
//

import Foundation
import SwiftUI
import PhotosUI
import Observation
import CommunityDomain
import Util

public protocol CommunityWriteViewModelProtocol {
  var title: String { get set }
  var content: String { get set }
  /// 선택된 이미지 목록
  var selectedImages: [SelectedImage] { get set }
  
  /// Photo picker 최대 선택 가능 갯수
  var maxSelectionCount: Int { get }
  
  /// 이미지 처리 중 상태
  var isProcessingImages: Bool { get set }
  
  /// 게시물 제출 중 상태
  var isSubmitting: Bool { get set }

  /// 이미지 크기 초과 알림 표시 여부
  var showImageSizeAlert: Bool { get set }
  
  /// 이미지 추가 가능 여부
  var canAddMoreImages: Bool { get }
  
  /// 이미지 카운터 텍스트
  var imageCountText: String { get }
  
  /// 제출 가능 여부
  var canSubmit: Bool { get }
  
  /// PhotosPicker에서 선택한 이미지 처리
  /// - Parameter items: 선택된 PhotosPickerItem 배열
  func handleImageSelection(_ items: [PhotosPickerItem]) async
  
  /// 이미지 삭제 (ID)
  /// - Parameter id: 삭제할 이미지의 ID
  func removeImage(id: UUID)
  
  func writeBoard(
    title: String,
    content: String,
    category: BoardCategory
  ) async -> Bool
}

@Observable
public final class CommunityWriteViewModel: CommunityWriteViewModelProtocol {
  public var title: String = ""
  public var content: String = ""
  // MARK: - Published State (auto-tracked by @Observable)
  /// 선택된 이미지 목록
  public var selectedImages: [SelectedImage] = []

  /// Photo picker 최대 선택 가능 갯수
  public var maxSelectionCount: Int {
    maxImages - selectedImages.count
  }
  
  /// 이미지 처리 중 상태
  public var isProcessingImages: Bool = false

  /// 게시물 제출 중 상태
  public var isSubmitting: Bool = false

  /// 에러 메시지
  public var errorMessage: String? = nil

  /// 이미지 크기 초과 알림 표시 여부
  public var showImageSizeAlert: Bool = false

  // MARK: - Constants

  /// 최대 이미지 개수
  private let maxImages: Int = 5

  // MARK: - Dependencies

  private let createBoardUseCase: CreateBoardUseCase

  // MARK: - Computed Properties

  /// 이미지 추가 가능 여부
  public var canAddMoreImages: Bool {
    selectedImages.count < maxImages
  }

  /// 이미지 카운터 텍스트
  public var imageCountText: String {
    "사진추가 (\(selectedImages.count)/\(maxImages))"
  }

  /// 제출 가능 여부
  public var canSubmit: Bool {
    !isSubmitting && !isProcessingImages
  }

  // MARK: - Initialization

  public init(createBoardUseCase: CreateBoardUseCase) {
    self.createBoardUseCase = createBoardUseCase
  }

  // MARK: - Image Selection

  /// PhotosPicker에서 선택한 이미지 처리
  /// - Parameter items: 선택된 PhotosPickerItem 배열
  public func handleImageSelection(_ items: [PhotosPickerItem]) async {
    guard canAddMoreImages else {
      return
    }

    isProcessingImages = true
    errorMessage = nil

    // 사용 가능한 슬롯 계산
    let availableSlots = maxImages - selectedImages.count
    let itemsToProcess = Array(items.prefix(availableSlots))

    for item in itemsToProcess {
      guard let imageData = try? await item.loadTransferable(type: Data.self),
            let image = UIImage(data: imageData) else {
        continue
      }

      let originalSize = imageData.count
      let fileName = "image_\(UUID().uuidString).jpg"

      // 크기 검증 (10MB)
      if originalSize > ImageProcessor.maxFileSize {
        // 처리 시도
        if let _ = ImageProcessor.process(image) {
          // 처리 성공
          let selectedImage = SelectedImage(
            image: image,
            originalSize: originalSize,
            fileName: fileName
          )
          selectedImages.append(selectedImage)
        } else {
          // 처리 실패
          showImageSizeAlert = true
        }
      } else {
        // 크기가 괜찮으면 바로 추가
        let selectedImage = SelectedImage(
          image: image,
          originalSize: originalSize,
          fileName: fileName
        )
        selectedImages.append(selectedImage)
      }
    }

    isProcessingImages = false
  }

  // MARK: - Image Management

  /// 이미지 삭제 (ID)
  /// - Parameter id: 삭제할 이미지의 ID
  public func removeImage(id: UUID) {
    selectedImages.removeAll { $0.id == id }
  }

  // MARK: - Board Creation

  /// 게시물 생성
  /// - Parameters:
  ///   - title: 제목
  ///   - content: 내용
  ///   - category: 카테고리
  /// - Returns: 성공 여부
  public func writeBoard(
    title: String,
    content: String,
    category: BoardCategory
  ) async -> Bool {
    guard canSubmit else { return false }
    guard !title.isEmpty && !content.isEmpty else {
      errorMessage = "제목과 내용을 입력해주세요"
      return false
    }

    isSubmitting = true
    errorMessage = nil

    do {
      let images = selectedImages.map { $0.image }

      _ = try await createBoardUseCase.execute(
        title: title,
        content: content,
        category: category,
        images: images
      )

      print("✅ Board created successfully with \(images.count) images")
      isSubmitting = false
      return true

    } catch {
      errorMessage = "게시글 작성에 실패했습니다: \(error.localizedDescription)"
      print("❌ Board creation error: \(error)")
      isSubmitting = false
      return false
    }
  }

  // MARK: - Reset

  /// 상태 초기화
  public func reset() {
    selectedImages.removeAll()
    errorMessage = nil
    showImageSizeAlert = false
  }
}

@Observable
public final class UpdateBoardViewModel: CommunityWriteViewModelProtocol {
  public var title: String = ""
  public var content: String = ""
  
  /// 최대 이미지 개수
  private let maxImages: Int = 5
  
  // MARK: - Dependencies
  private let boardId: Int
  private let boardDetailUseCase: BoardDetailUseCase
  private let updateBoardUseCase: UpdateBoardUseCase
  
  
  public init(
    boardId: Int,
    boardDetailUseCase: BoardDetailUseCase,
    updateBoardUseCase: UpdateBoardUseCase
  ) {
    self.boardId = boardId
    self.boardDetailUseCase = boardDetailUseCase
    self.updateBoardUseCase = updateBoardUseCase
    
    Task {
      let board = try? await boardDetailUseCase.getBoard(boardId: boardId)
      self.title = board?.title ?? ""
      self.content = board?.content ?? ""
      if let imageUrls = board?.imageUrls {
        for imageUrl in imageUrls {
          let url = URL(string: imageUrl)!
          
          guard
            let imageData = try? Data(contentsOf: url),
            let image = UIImage(data: imageData)
          else { return }
          
          let originalSize = imageData.count
          let fileName = "image_\(UUID().uuidString).jpg"
          self.selectedImages.append(
            SelectedImage(
              image: image,
              originalSize: originalSize,
              fileName: fileName
            )
          )
        }
      }
      
      
      
    }
    
  }
  
  public var selectedImages: [CommunityDomain.SelectedImage] = []
  
  /// Photo picker 최대 선택 가능 갯수
  public var maxSelectionCount: Int {
    maxImages - selectedImages.count
  }
  
  /// 이미지 처리 중 상태
  public var isProcessingImages: Bool = false

  /// 게시물 제출 중 상태
  public var isSubmitting: Bool = false
  
  /// 에러 메시지
  public var errorMessage: String? = nil
  
  /// 이미지 크기 초과 알림 표시 여부
  public var showImageSizeAlert: Bool = false
  
  /// 이미지 추가 가능 여부
  public var canAddMoreImages: Bool {
    selectedImages.count < maxImages
  }

  /// 이미지 카운터 텍스트
  public var imageCountText: String {
    "사진추가 (\(selectedImages.count)/\(maxImages))"
  }

  /// 제출 가능 여부
  public var canSubmit: Bool {
    !isSubmitting && !isProcessingImages
  }
  
  public func handleImageSelection(_ items: [PhotosPickerItem]) async {
    guard canAddMoreImages else {
      return
    }

    isProcessingImages = true
    errorMessage = nil

    // 사용 가능한 슬롯 계산
    let availableSlots = maxImages - selectedImages.count
    let itemsToProcess = Array(items.prefix(availableSlots))

    for item in itemsToProcess {
      guard let imageData = try? await item.loadTransferable(type: Data.self),
            let image = UIImage(data: imageData) else {
        continue
      }

      let originalSize = imageData.count
      let fileName = "image_\(UUID().uuidString).jpg"

      // 크기 검증 (10MB)
      if originalSize > ImageProcessor.maxFileSize {
        // 처리 시도
        if let _ = ImageProcessor.process(image) {
          // 처리 성공
          let selectedImage = SelectedImage(
            image: image,
            originalSize: originalSize,
            fileName: fileName
          )
          selectedImages.append(selectedImage)
        } else {
          // 처리 실패
          showImageSizeAlert = true
        }
      } else {
        // 크기가 괜찮으면 바로 추가
        let selectedImage = SelectedImage(
          image: image,
          originalSize: originalSize,
          fileName: fileName
        )
        selectedImages.append(selectedImage)
      }
    }

    isProcessingImages = false
  }
  
  public func removeImage(id: UUID) {
    selectedImages.removeAll { $0.id == id }
  }
  
  public func writeBoard(
    title: String,
    content: String,
    category: BoardCategory
  ) async -> Bool {
    guard canSubmit else { return false }
    
    guard !title.isEmpty && !content.isEmpty else {
      errorMessage = "제목과 내용을 입력해주세요"
      return false
    }
    
    isSubmitting = true
    errorMessage = nil

    do {
      let images = selectedImages.map { $0.image }
      
      _ = try await updateBoardUseCase.execute(
        boardId: boardId,
        title: title,
        content: content,
        category: category,
        images: images
      )

      print("✅ Board created successfully with \(images.count) images")
      isSubmitting = false
      return true

    } catch {
      errorMessage = "게시글 작성에 실패했습니다: \(error.localizedDescription)"
      print("❌ Board creation error: \(error)")
      isSubmitting = false
      return false
    }
  }
  
  // MARK: - Reset

  /// 상태 초기화
  public func reset() {
    selectedImages.removeAll()
    errorMessage = nil
    showImageSizeAlert = false
  }
}
