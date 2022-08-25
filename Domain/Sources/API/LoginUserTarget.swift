//
//  LoginUserTarget.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/25.
//

import Foundation
import Moya

extension Connection.GraphQL {
    public struct LoginUserTarget: BaseTarget {
        public typealias Response = LoginUser
        
        let token: String
        
        public init(token: String) {
            self.token = token
        }

        public var baseURL: URL {
            .init(string: "https://api.github.com")!
        }
        
        public var path: String {
            "graphql"
        }
        
        public var method: Moya.Method {
            .post
        }
        
        public var task: Task {
            var query =
                """
                {
                    \"query\": \"query { viewer { login }}\" \
                }
                """
            query = query.replacingOccurrences(
                of: "\n",
                with: ""
            )
            return .requestData(.init(query.utf8))
        }
        
        public var headers: [String: String]? {
            ["Authorization": "bearer \(token)"]
        }
    }
}
