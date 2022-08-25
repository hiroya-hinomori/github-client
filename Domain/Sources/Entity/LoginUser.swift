//
//  LoginUser.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation

public struct LoginUser: Decodable {
    public let name: String
    
    public init(from decoder: Decoder) throws {
        enum RootKeys: String, CodingKey {
            case data
        }
        enum DataKeys: String, CodingKey {
            case viewer
        }
        enum ViewerKeys: String, CodingKey {
            case login
        }

        let root = try decoder.container(keyedBy: RootKeys.self)
        let data = try root.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let viewer = try data.nestedContainer(keyedBy: ViewerKeys.self, forKey: .viewer)
        name = try viewer.decode(String.self, forKey: .login)
    }
}
