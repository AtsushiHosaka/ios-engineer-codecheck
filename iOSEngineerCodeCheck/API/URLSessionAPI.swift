//
//  URLSessionAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by 保坂篤志 on 2024/09/29.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import UIKit

class URLSessionAPI {
    static func fetchImage(imgUrl: String) async throws -> UIImage {
        let url = try createURL(of: imgUrl)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let img = UIImage(data: data) else {
            throw NSError(domain: "URLSessionAPIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from data."])
        }
        
        return img
    }
}
