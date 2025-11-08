//
//  FontProvider.swift
//  Hambug
//
//  Created by 강동영 on 8/26/25.
//

import Foundation

// MARK: - Font Provider Protocol
public protocol FontProvider {
    var regular: String { get }
    var medium: String { get }
    var semiBold: String { get }
    var bold: String? { get }
}

// MARK: - Pretendard Font Provider
public struct PretendardProvider: FontProvider {
    public let regular: String = "Pretendard-Regular"
    public let medium: String = "Pretendard-Medium"
    public let semiBold: String = "Pretendard-SemiBold"
    public let bold: String? = nil
    
    public init() {}
}

// MARK: - Font Weight Enum
public enum FontWeight {
    case regular, medium, semiBold, bold
    
    public func getFontName(from provider: FontProvider) -> String {
        switch self {
        case .regular: return provider.regular
        case .medium: return provider.medium
        case .semiBold: return provider.semiBold
        case .bold: return provider.bold ?? provider.semiBold
        }
    }
}
