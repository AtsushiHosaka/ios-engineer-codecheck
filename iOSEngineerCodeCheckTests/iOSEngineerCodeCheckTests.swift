//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class iOSEngineerCodeCheckTests: XCTestCase {

    var searchVC: SearchViewController!
    var repository: Repository!

    override func setUpWithError() throws {
        super.setUp()
        // SearchViewControllerのセットアップ
        searchVC = SearchViewController()
        searchVC.loadViewIfNeeded()

        // サンプルリポジトリデータのセットアップ
        let owner = RepositoryOwner(avatarUrl: "https://example.com/avatar.png")
        repository = Repository(language: "Swift", fullName: "sample/repo", stargazersCount: 100, watchersCount: 50, forksCount: 10, openIssuesCount: 5, owner: owner)
    }

    override func tearDownWithError() throws {
        searchVC = nil
        repository = nil
        super.tearDown()
    }

    // リポジトリリストのセル数をテスト
    func testNumberOfRowsInSection() throws {
        searchVC.repositoryList = [repository, repository]
        let rows = searchVC.tableView(searchVC.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 2, "TableViewのセル数が正しくありません。")
    }

    // セル内容のテスト
    func testCellForRowAt() throws {
        searchVC.repositoryList = [repository]
        let cell = searchVC.tableView(searchVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "sample/repo", "リポジトリ名が正しく表示されていません。")
        XCTAssertEqual(cell.detailTextLabel?.text, "Swift", "言語情報が正しく表示されていません。")
    }

    // リポジトリ検索APIのレスポンスデコードのテスト
    func testRepositoryDecoding() throws {
        let jsonData = """
        {
            "items": [{
                "full_name": "sample/repo",
                "language": "Swift",
                "stargazers_count": 100,
                "watchers_count": 50,
                "forks_count": 10,
                "open_issues_count": 5,
                "owner": {
                    "avatar_url": "https://example.com/avatar.png"
                }
            }]
        }
        """.data(using: .utf8)!
        
        let repositories = try GithubAPI.testDecodeRepository(from: jsonData)
        XCTAssertEqual(repositories.count, 1, "デコード結果のリポジトリ数が異なります。")
        XCTAssertEqual(repositories[0].fullName, "sample/repo", "デコードされたリポジトリ名が正しくありません。")
    }
}
