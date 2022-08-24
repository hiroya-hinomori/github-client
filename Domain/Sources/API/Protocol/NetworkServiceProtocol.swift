//
//  NetworkServiceProtocol.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation

public protocol NetworkServiceProtocol {
    func requestLoginUserName(_ completion: @escaping (Result<LoginUser, Error>) -> ())
    func requestRepository(_ completion: @escaping (Result<Repositories, Error>) -> ())
}
