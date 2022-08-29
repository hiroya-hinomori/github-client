//
//  Repository.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation

public protocol RepositoryType {
    var url: URL { get }
    var name: String { get }
    var isPrivate: Bool { get }
}

public struct Repositories: Decodable {
    public struct Repository: Decodable, Equatable, RepositoryType {
        public let url: URL
        public let name: String
        public let isPrivate: Bool
    }
    
    public let list: [RepositoryType]
    
    public init(from decoder: Decoder) throws {
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
