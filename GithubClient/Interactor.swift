//
//  Interactor.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation
import Domain

class Interactor: ObservableObject {
    @Published var userName = ""
    @Published var list: [Repositories.Repository] = []
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchLoginUser() {
        networkService
            .requestLoginUserName {
                switch $0 {
                case .success(let user):
                    self.userName = user.name
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func fetchRepositories() {
        networkService
            .requestRepository {
                switch $0 {
                case .success(let repo):
                    self.list = repo.list
                case .failure(let error):
                    print(error)
                }
            }
    }
}
