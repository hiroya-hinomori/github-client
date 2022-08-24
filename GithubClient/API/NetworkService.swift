//
//  NetworkService.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation
import Moya

struct NetworkService {
    let provider: MoyaProvider<GitHubRouter>
    let token: String
    
    init(token: String) {
        provider = .init()
        self.token = token
    }
    
    func requestLoginUserName(_ completion: @escaping (Result<LoginUser, Error>) -> ()) {
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
    
    func requestRepository(_ completion: @escaping (Result<Repositories, Error>) -> ()) {
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
    
    func requestCheck(_ completion: @escaping (Result<String, Error>) -> ()) {
        let githubRouter = GitHubRouter(token: token, type: .repogitories)
        provider.request(githubRouter) { result in
            switch result {
            case .success(let response):
                completion(.success(String(data: response.data, encoding: .utf8)!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
