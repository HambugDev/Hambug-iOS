//
//  FontProvider.swift
//  Hambug
//
//  Created by 강동영 on 8/26/25.
//

import Foundation

// MARK: - Font Provider Protocol
protocol FontProvider {
    var regular: String { get }
    var medium: String { get }
    var semiBold: String { get }
    var bold: String? { get }
}

// MARK: - Pretendard Font Provider
struct PretendardProvider: FontProvider {
    let regular: String = "Pretendard-Regular"
    let medium: String = "Pretendard-Medium"
    let semiBold: String = "Pretendard-SemiBold"
    let bold: String? = nil
}

// MARK: - Font Weight Enum
enum FontWeight {
    case regular, medium, semiBold, bold
    
    func getFontName(from provider: FontProvider) -> String {
        switch self {
        case .regular: return provider.regular
        case .medium: return provider.medium
        case .semiBold: return provider.semiBold
        case .bold: return provider.bold ?? provider.semiBold
        }
    }
}
