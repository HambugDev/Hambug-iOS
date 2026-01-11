//
//  CommunityReportViewModel.swift
//  Community
//
//  Created by 강동영 on 1/8/26.
//


import Foundation
import Observation
import CommunityDomain

@Observable
public class CommunityReportViewModel {
  private let usecase: ReportContentUseCase
  private let targetId: Int
  private let targetType: ReportTargetType
  
  private let _maxCharacterCount = 300
  
  var title: String = ""
  var content: String = ""
  var maxCharacterCount: Int { _maxCharacterCount }
  
  // 게시물 제출 중 상태
  public var isSubmitting: Bool = false
  
  /// 제출 가능 여부
  public var canSubmit: Bool { !isSubmitting }
  
  public var errorMessage: String? = nil
  
  public init(
    usecase: ReportContentUseCase,
    reportInfo: ReportRequest
  ) {
    self.usecase = usecase
    self.targetId = reportInfo.targetId
    self.targetType = reportInfo.targetType
  }
  
  // MARK: - Report Methods
  func report() async {
    let request: ReportRequest = .init(
      targetId: targetId,
      targetType: targetType,
      reason: "\(title): \(content)"
    )
    
    do {
      try await usecase.execute(request: request)
      print("✅ Content reported")
    } catch {
      errorMessage = error.localizedDescription
      print("❌ Report error: \(error)")
    }
  }
}
