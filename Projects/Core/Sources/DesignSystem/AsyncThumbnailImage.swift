//
//  AsyncThumbnailImage.swift
//  Common
//
//  Created by 강동영 on 1/12/26.
//

import SwiftUI

public struct AsyncThumbnailImage: View {
  private let imageURL: String?
  private let width: CGFloat?
  private let height: CGFloat?
  private let cornerRadius: CGFloat
  
  public init(
    imageURL: String?,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    cornerRadius: CGFloat = 8
  ) {
    self.imageURL = imageURL
    self.width = width
    self.height = height
    self.cornerRadius = cornerRadius
  }
  
  public var body: some View {
    content
      .frame(width: width, height: height)
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
  }
  
  @ViewBuilder
  private var content: some View {
    if let imageURL = imageURL,
       !imageURL.isEmpty,
       let url = URL(string: imageURL) {
      AsyncImage(url: url) { phase in
        if case .success(let image) = phase {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        }
      }
    }
  }
}
