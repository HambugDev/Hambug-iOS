//
//  ProfileImageView.swift
//  Common
//
//  Created by 강동영 on 1/11/26.
//

import SwiftUI

public struct ProfileImageView: View {
  private let imageUrlString: String
  private var width: CGFloat
  private var height: CGFloat
  private var fillColor: Color
  
  public init(
    with imageUrlString: String,
    width: CGFloat = 32,
    height: CGFloat = 32,
    fillColor: Color = Color.bgG200
  ) {
    self.imageUrlString = imageUrlString
    self.width = width
    self.height = height
    self.fillColor = fillColor
  }
  
  public var body: some View {
    AsyncImage(url: URL(string: imageUrlString)) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: width, height: height)
      case .empty, .failure:
        Image(.placeholderProfile)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: width, height: height)
      @unknown default:
        Image(.placeholderProfile)
          .resizable()
          .aspectRatio(contentMode: .fill)
        .frame(width: width, height: height)      }
    }
  }
}

public extension ProfileImageView {
  func applyCilpShape() -> some View {
    self.clipShape(Circle())
  }
}
