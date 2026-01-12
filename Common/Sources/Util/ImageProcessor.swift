//
//  ImageProcessor.swift
//  Common
//
//  Created by 강동영 on 1/8/26.
//

import UIKit

/// 이미지 리사이징 및 압축 유틸리티
public enum ImageProcessor {

  // MARK: - Constants

  /// 최대 파일 크기: 10MB
  public static let maxFileSize: Int = 2 * 1024 * 1024

  /// 최대 해상도: 1280px
  public static let maxDimension: CGFloat = 1280

  /// 기본 압축 품질
  public static let compressionQuality: CGFloat = 0.85

  // MARK: - Public Methods

  /// 이미지를 처리 (리사이징 + 압축)
  /// - Parameter image: 원본 UIImage
  /// - Returns: 처리된 JPEG Data (10MB 이하), 실패 시 nil
  public static func process(_ image: UIImage) -> Data? {
    // 1. 해상도가 초과하면 리사이징
    let resizedImage = resize(image, maxDimension: maxDimension)

    // 2. JPEG 압축
    guard var imageData = resizedImage.jpegData(compressionQuality: compressionQuality) else {
      return nil
    }

    // 3. 10MB 초과 시 품질을 낮추며 재압축
    var currentQuality = compressionQuality
    while imageData.count > maxFileSize && currentQuality > 0.5 {
      currentQuality -= 0.1
      guard let compressedData = resizedImage.jpegData(compressionQuality: currentQuality) else {
        break
      }
      imageData = compressedData
    }

    // 4. 최종 크기 검증
    return imageData.count <= maxFileSize ? imageData : nil
  }

  /// 예상 파일 크기 계산 (RGBA 기준)
  /// - Parameter image: UIImage
  /// - Returns: 예상 크기 (bytes)
  public static func estimatedSize(of image: UIImage) -> Int {
    return Int(image.size.width * image.size.height * 4)
  }

  // MARK: - Private Methods

  /// 이미지 해상도 조정 (비율 유지)
  /// - Parameters:
  ///   - image: 원본 이미지
  ///   - maxDimension: 최대 너비/높이
  /// - Returns: 리사이징된 이미지
  private static func resize(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
    let size = image.size

    // 이미 범위 내에 있으면 원본 반환
    if size.width <= maxDimension && size.height <= maxDimension {
      return image
    }

    // 새로운 크기 계산 (비율 유지)
    let aspectRatio = size.width / size.height
    let newSize: CGSize

    if size.width > size.height {
      // 가로가 더 긴 경우
      newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
    } else {
      // 세로가 더 긴 경우
      newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
    }

    // 리사이징 수행
    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { _ in
      image.draw(in: CGRect(origin: .zero, size: newSize))
    }
  }
}
