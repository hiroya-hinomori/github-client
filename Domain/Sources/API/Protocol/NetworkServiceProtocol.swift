//
//  NetworkServiceProtocol.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation

public protocol NetworkServiceProtocol {
    func request<R: BaseTarget>(_ target: R, completion: @escaping (Result<R.Response, Error>) -> Void)
}
