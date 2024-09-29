//
//  RepositoryOwner.swift
//  iOSEngineerCodeCheck
//
//  Created by 保坂篤志 on 2024/09/29.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryOwner: Decodable {
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
