//
//  Repository.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation

struct Repositories: Decodable {
    struct Repository: Decodable {
        let url: URL
        let name: String
    }
    
    let list: [Repository]
    
    init(from decoder: Decoder) throws {
        enum RootKeys: String, CodingKey {
            case data
        }
        enum DataKeys: String, CodingKey {
            case viewer
        }
        enum ViewerKeys: String, CodingKey {
            case repositories
        }
        enum RepositoriesKeys: String, CodingKey {
            case nodes
        }

        let root = try decoder.container(keyedBy: RootKeys.self)
        let data = try root.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let viewer = try data.nestedContainer(keyedBy: ViewerKeys.self, forKey: .viewer)
        let repo = try viewer.nestedContainer(keyedBy: RepositoriesKeys.self, forKey: .repositories)

        list = try repo.decode([Repository].self, forKey: .nodes)
    }

}
