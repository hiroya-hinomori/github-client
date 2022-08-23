//
//  GithubClientApp.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/23.
//

import SwiftUI

@main
struct GithubClientApp: App {
    let gat = Bundle.main.object(forInfoDictionaryKey: "GAT") as! String
    
    var body: some Scene {
        WindowGroup {
            ContentView(token: gat)
        }
    }
}
