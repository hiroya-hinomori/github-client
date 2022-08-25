//
//  AbstractTarget.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/25.
//

import Moya
import UIKit

enum AbstractTarget: TargetType {
    case target(_ target: TargetType, sampleData: Data?, baseURL: URL?)

    public init(_ target: TargetType, sampleData: Data?, baseURL: URL?) {
        self = .target(target, sampleData: sampleData, baseURL: baseURL)
    }

    public var path: String {
        target.path
    }

    public var baseURL: URL {
        switch self {
        case let .target(_, _, url): return url ?? target.baseURL
        }
    }

    public var method: Moya.Method {
        target.method
    }

    public var sampleData: Data {
        class Ancher { }
        
        if case .target(_, let data, _) = self, let sampleData = data {
            return sampleData
        }
        switch target {
        case _ as Connection.GraphQL.LoginUserTarget:
            return NSDataAsset(name: "LoginUser", bundle: .init(for: Ancher.self))!.data
        case _ as Connection.GraphQL.RepositoriesTarget:
            return NSDataAsset(name: "Repositories", bundle: .init(for: Ancher.self))!.data
        default:
            return target.sampleData
        }
    }

    public var task: Task {
        target.task
    }

    public var validationType: ValidationType {
        target.validationType
    }

    public var headers: [String: String]? {
        target.headers
    }

    public var target: TargetType {
        switch self {
        case let .target(target, _, _): return target
        }
    }
}
