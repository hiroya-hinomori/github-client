//
//  RootView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/09/07.
//

import SwiftUI
import Domain

struct RootView: View {
    let gat: String
    let networkService: NetworkServiceProtocol

    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: {
                    RepositoryListView(
                        store: .init(
                            initialState: .init(),
                            reducer: RepositoryListStore.reducer.debug(),
                            environment: .init(
                                accessToken: gat,
                                interactor: .init(networkService: networkService)
                            )
                        )
                    )
                }) {
                    Text("Show List")
                }

                NavigationLink(destination: {
                    HomeView(
                        store: .init(
                            initialState: .init(),
                            reducer: HomeStore.reducer.debug(),
                            environment: .init(
                                accessToken: gat,
                                interactor: .init(networkService: networkService)
                            )
                        )
                    )
                }) {
                    Text("Use IfLetStore")
                }
            }
            .navigationTitle("Repository List")
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(gat: "", networkService: StubNetworkService())
    }
}
