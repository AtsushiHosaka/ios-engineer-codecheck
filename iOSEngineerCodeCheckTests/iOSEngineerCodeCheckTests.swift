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
    
    override func setUpWithError() throws {
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
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
        let repo = repositories[0]
        
        XCTAssertEqual(repositories.count, 1, "デコード結果のリポジトリ数が異なります。")
        XCTAssertEqual(repo.fullName, "sample/repo", "デコードされたリポジトリ名が正しくありません。")
        XCTAssertEqual(repo.language, "Swift", "デコードされたプログラミング言語が正しくありません。")
        XCTAssertEqual(repo.stargazersCount, 100, "スターの数が正しくありません。")
        XCTAssertEqual(repo.watchersCount, 50, "ウォッチャーの数が正しくありません。")
        XCTAssertEqual(repo.forksCount, 10, "フォークの数が正しくありません。")
        XCTAssertEqual(repo.openIssuesCount, 5, "オープンされているissueの数が正しくありません。")
        XCTAssertEqual(repo.owner.avatarUrl, "https://example.com/avatar.png", "アバターURLが正しくありません。")
    }
}
