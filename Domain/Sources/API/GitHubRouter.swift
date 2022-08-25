//
//  GitHubRouter.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation
import Moya

struct GitHubRouter: TargetType {
    enum GraphQLType {
        case loginName
        case repogitories
    }
    let token: String
    let type: GraphQLType
    
    var baseURL: URL {
        .init(string: "https://api.github.com")!
    }
    
    var path: String {
        "graphql"
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Task {
        var query: String
        switch type {
        case .loginName:
            query =
                """
                {
                    \"query\": \"query { viewer { login }}\" \
                }
                """
        case .repogitories:
            query =
                """
                {
                    \"query\": \"query {
                        viewer {
                            repositories(last: 10) {
                                nodes {
                                    name
                                    url
                                }
                            }
                        }
                    }\" \
                }
                """
        }
        query = query.replacingOccurrences(
            of: "\n",
            with: ""
        )
        return .requestData(.init(query.utf8))
    }
    
    var headers: [String: String]? {
        ["Authorization": "bearer \(token)"]
    }
}
