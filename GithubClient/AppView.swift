//
//  AppView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/30.
//

import SwiftUI
import Domain

struct AppView: View {
    let gat: String
    let networkService: NetworkServiceProtocol
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination:
                    ComposableArchitectureView(
                        store: .init(
                            initialState: .init(
                                userName: "",
                                repositoryList: []
                            ),
                            reducer: composableArchitectureReducer,
                            environment: .init(
                                accessToken: gat,
                                interactor: .init(networkService: networkService)
                            )
                        )
                    )
                ) {
                    Text("Composable Architecture")
                }
            }
            .navigationTitle("Github Client App")
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(gat: "", networkService: StubNetworkService())
    }
}
