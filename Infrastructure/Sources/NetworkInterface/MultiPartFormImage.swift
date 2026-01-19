//
//  MultiPartFormImage.swift
//  Infrastructure
//
//  Created by 강동영 on 1/19/26.
//

import Foundation

public struct MultiPartFormType {
  public let data: Data
  public let fiedlName: String
  public let fileName: String?
  public let mimeType: String?
  
  public init(
    data: Data,
    fiedlName: String = "images",
    fileName: String? = nil,
    mimeType: String? = nil/*"image/jpeg"*/
  ) {
    self.data = data
    self.fiedlName = fiedlName
    self.fileName = fileName
    self.mimeType = mimeType
  }
}
