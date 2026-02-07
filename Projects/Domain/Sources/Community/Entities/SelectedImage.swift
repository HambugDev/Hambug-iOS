//
//  SelectedImage.swift
//  Community
//
//  Created by 강동영 on 1/8/26.
//

import Foundation
import UIKit

/// 사용자가 선택한 이미지를 나타내는 엔티티
public struct SelectedImage: Identifiable, Sendable {

  /// 고유 ID
  public let id: UUID

  /// 이미지 객체 (Sendable을 위해 @unchecked 사용)
  public let image: UIImage

  /// 원본 파일 크기 (bytes)
  public let originalSize: Int

  /// 파일 이름
  public let fileName: String

  /// 초기화
  /// - Parameters:
  ///   - id: 고유 ID (기본값: UUID())
  ///   - image: UIImage 객체
  ///   - originalSize: 원본 크기 (bytes)
  ///   - fileName: 파일 이름
  public init(
    id: UUID = UUID(),
    image: UIImage,
    originalSize: Int,
    fileName: String
  ) {
    self.id = id
    self.image = image
    self.originalSize = originalSize
    self.fileName = fileName
  }
}

// MARK: - Sendable Conformance
// UIImage는 기본적으로 Sendable이 아니지만, 이미지 처리 시 불변으로 사용하므로 안전
extension UIImage: @unchecked Sendable {}
