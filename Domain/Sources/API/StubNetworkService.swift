//
//  StubNetworkService.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation
import Moya

struct StubNetworkService: NetworkServiceProtocol {
    class Ancher { }
    
    let provider = MoyaProvider<AbstractTarget>(stubClosure: MoyaProvider.immediatelyStub)
    
    func request<R>(_ target: R, completion: @escaping (Result<R.Response, Error>) -> Void) where R : BaseTarget {
        let abstractTarget = AbstractTarget(target, sampleData: nil, baseURL: nil)
        let decoder = JSONDecoder()
        provider
            .request(abstractTarget) {
                switch $0 {
                case .success(let response):
                    do {
                        let decodeData = try decoder.decode(R.Response.self, from: response.data)
                        completion(.success(decodeData))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
