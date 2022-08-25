//
//  BaseTarget.swift
//  Domain
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/25.
//

import Foundation
import Moya

public protocol BaseTarget: TargetType {
    associatedtype Response: Decodable
}
