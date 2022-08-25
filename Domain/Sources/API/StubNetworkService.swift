//
//  StubNetworkService.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/24.
//

import Foundation
import UIKit

struct StubNetworkService: NetworkServiceProtocol {
    class Ancher { }
    
    let bundle = Bundle(for: Ancher.self)
    
    func requestLoginUserName(_ completion: @escaping (Result<LoginUser, Error>) -> ()) {
        let asset = NSDataAsset(name: "LoginUser", bundle: bundle)
        let json = try! JSONSerialization.jsonObject(with: asset!.data, options: .fragmentsAllowed)
        print(json)
    }
    
    func requestRepository(_ completion: @escaping (Result<Repositories, Error>) -> ()) {
        
    }
}
