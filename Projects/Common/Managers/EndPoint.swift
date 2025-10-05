//
//  EndPoint.swift
//  Hambug
//
//  Created by 차상진 on 10/5/25.
//

import Foundation

enum Endpoint {
    case auth
}

extension Endpoint {
    var urlString: String {
        switch self {
        case .auth:
            return .makeForEndPoint("/auth/me")
        }
    }
}

extension String {
    static let baseURL = "https://hambug.p-e.kr/api/v1"
    
    static func makeForEndPoint(_ endPoint: String) -> String {
        baseURL + endPoint
    }
}

