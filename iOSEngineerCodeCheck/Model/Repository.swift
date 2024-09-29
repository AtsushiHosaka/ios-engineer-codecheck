//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by 保坂篤志 on 2024/09/29.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let language: String
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}
