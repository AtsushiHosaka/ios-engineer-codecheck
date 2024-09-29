//
//  GithubAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by 保坂篤志 on 2024/09/29.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation

class GithubAPI {
    static func fetchRepositories(searchWord: String) async throws -> [Repository]? {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let repositories = try decodeRepository(from: data) {
            return repositories
        }
        
        return nil
    }
    
    static func decodeRepository(from jsonData: Data) throws -> [Repository]? {
        let decoder = JSONDecoder()
        
        let response = try decoder.decode([String: [Repository]].self, from: jsonData)
        return response["items"]
    }
}
