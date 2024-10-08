//
//  RepositoryOwner.swift
//  iOSEngineerCodeCheck
//
//  Created by 保坂篤志 on 2024/09/29.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit

struct RepositoryOwner: Decodable {
    let avatarUrl: String
    var image: UIImage?
    
    init(avatarUrl: String, image: UIImage? = nil) {
        self.avatarUrl = avatarUrl
        self.image = image
    }
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
