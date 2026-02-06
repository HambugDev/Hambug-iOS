//
//  UITestProtocols.swift
//  Hambug
//
//  Created by 강동영 on 2/7/26.
//

import XCTest

/// 키보드 타이핑 가능
protocol UITypingAvailable {
  func typingText(_ text: String)
}

extension UITypingAvailable where Self: TestUIBase {
  func typingText(_ text: String) {
    guard let app = app else {
      XCTAssert(false, "app 초기화 안됌")
      return
    }
    
    text.forEach {
      app.keyboards.keys[String($0)].tap()
    }
  }
  
  func deleteText(repeatCnt: Int) {
    let key = "Delete"
    for _ in 0..<repeatCnt {
      self.app?.keyboards.keys[key].tap()
    }
  }
}

/// 탭 가능
protocol UITapAvailable {
  associatedtype TapAvailables
  
  func tap(_ tap: TapAvailables)
}

/// 존재 여부 체크
protocol UICheckExistAvailable {
  associatedtype CheckExistAvailables
  func checkExist(_ object: CheckExistAvailables, isExist: Bool)
}

/// 일치 여부 체크
protocol UICheckMatchAvailable {
  associatedtype CheckMatchAvailables
  func checkMatch(_ object: CheckMatchAvailables, text: String)
}

/// 금액 상태 확인
protocol UICheckValidPriceAvailalbe {
  associatedtype UICheckValidPriceAvailalbes
  func checkPrice(_ object: UICheckValidPriceAvailalbes)
  func matchPrice(_ object: UICheckValidPriceAvailalbes, comparePrice: Int)
}
/// 터치 가능 여부 체크
protocol UICheckHitAvailable {
  associatedtype CheckHitAvailables
  func checkHittable(_ object: CheckHitAvailables, isHittable: Bool)
}

/// 리스트 선택
protocol UISelectTableCellAvailable {
  func selectTableCell(index: Int)
  func selectTableCell(text: String)
}

extension UISelectTableCellAvailable where Self: TestUIBase {
  func selectTableCell(text: String) {
    app?.tables.cells.staticTexts[text].firstMatch.tap()
  }
  
  func selectTableCell(index: Int) {
    guard let cellCnt = app?.tables.cells.count,
          cellCnt > 0,
          cellCnt > index else { return }
    app?.tables.cells.allElementsBoundByIndex[index].tap()
  }
}

/// CollectionView Cell 선택
protocol UISelectCollectionCellAvailable {
  func selectCollectionCell(index: Int)
  func selectCollectionCell(text: String)
}

extension UISelectCollectionCellAvailable where Self: TestUIBase {
  func selectCollectionCell(text: String) {
    app?.collectionViews.cells.staticTexts[text].firstMatch.tap()
  }
  
  func selectCollectionCell(index: Int) {
    guard let cellCnt = app?.collectionViews.cells.count,
          cellCnt > 0,
          cellCnt > index else { return }
    app?.collectionViews.cells.allElementsBoundByIndex[index].tap()
  }
}
