//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSearchBarInput() throws {
        let searchBar = app.searchFields["searchBar"]
        XCTAssertTrue(searchBar.exists, "検索バーが表示されていません。")
        
        searchBar.tap()
        
        // キーボードが表示されるまで待機
        let keyboard = app.keyboards.firstMatch
        XCTAssertTrue(keyboard.waitForExistence(timeout: 5), "キーボードが表示されませんでした。")
        
        searchBar.typeText("Swift\n")
        
        // 検索結果が表示されるまで待機
        let table = app.tables.element(boundBy: 0)
        XCTAssertTrue(table.waitForExistence(timeout: 5), "検索結果が表示されませんでした。")
    }
    
    func testDetailViewNavigation() throws {
        let table = app.tables.element(boundBy: 0)
        
        if table.cells.count > 0 {
            let firstCell = table.cells.element(boundBy: 0)
            firstCell.tap()
            
            let detailTitleLabel = app.staticTexts["titleLabel"]
            XCTAssertTrue(detailTitleLabel.exists, "詳細画面のタイトルラベルが表示されていません。")
        }
    }
    
    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                app.launch()
            }
        }
    }
}
