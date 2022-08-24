//
//  NetworkService.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation
import Moya

public struct NetworkService {
    let provider: MoyaProvider<GitHubRouter>
    let token: String
    
    public init(token: String) {
        provider = .init()
        self.token = token
    }
    
    public func requestLoginUserName(_ completion: @escaping (Result<LoginUser, Error>) -> ()) {
        let githubRouter = GitHubRouter(token: token, type: .loginName)
        provider.request(githubRouter) { result in
            switch result {
            case .success(let response):
                completion(.success(try! JSONDecoder().decode(LoginUser.self, from: response.data)))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    public func requestRepository(_ completion: @escaping (Result<Repositories, Error>) -> ()) {
        let githubRouter = GitHubRouter(token: token, type: .repogitories)
        provider.request(githubRouter) { result in
            switch result {
            case .success(let response):
                completion(.success(try! JSONDecoder().decode(Repositories.self, from: response.data)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
