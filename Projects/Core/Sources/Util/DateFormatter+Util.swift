//
//  DateFormatter+Util.swift
//  Common
//
//  Created by 강동영 on 1/9/26.
//

import Foundation

public extension DateFormatter {
  static let iso8601WithMicroseconds: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
  }()
}
