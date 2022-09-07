//
//  RepositoryListView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/09/07.
//

import SwiftUI
import ComposableArchitecture
import Domain

struct RepositoryListView: View {
    let store: Store<RepositoryListStore.State, RepositoryListStore.Action>
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Form {
                    ForEach(viewStore.rows) { row in
                        NavigationLink(
                            destination: WebView(url: row.repository.url),
                            tag: row.id,
                            selection: viewStore.binding(
                                get: \.selection?.id,
                                send: RepositoryListStore.Action.setNavigation(id:)
                            )
                        ) {
                            ListItemView(repository: row.repository)
                        }
                    }
                    .navigationTitle(viewStore.userName ?? "")
                }
                if viewStore.isShowIndicator {
                    LoadingView()
                }
            }
            .alert(
                store.scope(state: \.alert?.state),
                dismiss: .dismissAlert
            )
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RepositoryListView(
                store: .init(
                    initialState: .init(
                        userName: "hoge",
                        isShowIndicator: false
                    ),
                    reducer: RepositoryListStore.reducer,
                    environment: .init(
                        accessToken: "fuga",
                        interactor: .init(networkService: StubNetworkService())
                    )
                )
            )
        }
    }
}
