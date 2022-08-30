//
//  GithubClientApp.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/23.
//

import SwiftUI
import Domain

@main
struct GithubClientApp: App {
    let gat = Bundle.main.object(forInfoDictionaryKey: "GAT") as! String
    let networkService = NetworkService()
    
    var body: some Scene {
        WindowGroup {
            AppView(gat: gat, networkService: networkService)
//            NavigationView {
//                RootView(
//                    store: .init(
//                        initialState: .init(
//                            userName: "",
//                            repositoryList: []
//                        ),
//                        reducer: rootReducer,
//                        environment: .init(
//                            accessToken: gat,
//                            interactor: .init(networkService: networkService)
//                        )
//                    )
//                )
//            }
        }
    }
}
