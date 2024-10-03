//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by 保坂篤志 on 2024/09/29.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let language: String?
    let fullName: String
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    var owner: RepositoryOwner
    
    init(language: String?, fullName: String, stargazersCount: Int, watchersCount: Int, forksCount: Int, openIssuesCount: Int, owner: RepositoryOwner) {
        self.language = language
        self.fullName = fullName
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
        self.owner = owner
    }
    
    enum CodingKeys: String, CodingKey {
        case language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner
    }
}
