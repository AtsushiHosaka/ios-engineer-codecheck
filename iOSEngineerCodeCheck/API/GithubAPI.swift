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
    
    static private func decodeRepository(from jsonData: Data) throws -> [Repository]? {
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(GithubRepositoryResponse.self, from: jsonData)
        
        return response.items
    }
    
    struct GithubRepositoryResponse: Decodable {
        let items: [Repository]
        let incompleteResults: Bool?
        let totalCount: Int?
        
        init(items: [Repository], incompleteResults: Bool?, totalCount: Int?) {
            self.items = items
            self.incompleteResults = incompleteResults
            self.totalCount = totalCount
        }
        
        enum CodingKeys: String, CodingKey {
            case items
            case incompleteResults = "incomplete_results"
            case totalCount = "total_count"
        }
    }
}
