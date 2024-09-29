//
//  URLSessionAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by 保坂篤志 on 2024/09/29.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit

class URLSessionAPI {
    static func fetchImage(imgUrl: String) async throws -> UIImage? {
        guard let url = URL(string: imgUrl) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let img = UIImage(data: data) else {
            print("error: cannot create image from \(url)")
            return nil
        }
        
        return img
    }
}
