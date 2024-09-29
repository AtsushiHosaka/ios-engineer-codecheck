//
//  CreateURL.swift
//  iOSEngineerCodeCheck
//
//  Created by 保坂篤志 on 2024/09/29.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

func createURL(of rawString: String) throws -> URL {
    guard let url = URL(string: rawString) else {
        throw URLError(.badURL)
    }
    
    return url
}
