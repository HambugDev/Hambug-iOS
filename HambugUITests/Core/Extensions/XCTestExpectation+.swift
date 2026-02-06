//
//  XCTestExpectation+.swift
//  Hambug
//
//  Created by 강동영 on 2/7/26.
//

import XCTest

extension XCTestExpectation {
  static var delay: XCTestExpectation {
    let delay = XCTestExpectation()
    delay.isInverted = true
    return delay
  }
}
