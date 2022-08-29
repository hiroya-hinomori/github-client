//
//  Interactor.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation
import Domain

class Interactor: ObservableObject {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchAsyncLoginUser(with token: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            networkService
                .request(
                    Connection.GraphQL.LoginUserTarget(token: token),
                    completion: {
                        switch $0 {
                        case .success(let user):
                            continuation.resume(returning: user.name)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                )
        }
    }

    func fetchAsyncRepositories(with token: String) async throws -> [RepositoryType] {
        try await withCheckedThrowingContinuation { continuation in
            networkService
                .request(
                    Connection.GraphQL.RepositoriesTarget(token: token),
                    completion: {
                        switch $0 {
                        case .success(let repo):
                            continuation.resume(returning: repo.list)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }

                    }
                )
        }
    }
}
