//
//  IfLetStoreView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/30.
//

import ComposableArchitecture
import SwiftUI
import Domain

struct IfLetStoreView: View {
    let store: Store<IfLetStoreStore.State, IfLetStoreStore.Action>
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                ForEach(viewStore.rows) { row in
                    NavigationLink(
                        destination: IfLetStore(
                            self.store.scope(
                                state: \.selection?.value,
                                action: IfLetStoreStore.Action.browse
                            )
                        ) {
                            TCAWebView(store: $0)
                        },
                        tag: row.id,
                        selection: viewStore.binding(
                            get: \.selection?.id,
                            send: IfLetStoreStore.Action.setNavigation(id:)
                        )
                    ) {
                        ListItemView(repository: row.repository)
                    }
                }
                .navigationTitle(viewStore.userName)
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

struct IfLetStoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IfLetStoreView(
                store: .init(
                    initialState: .init(
                        userName: "hoge"
                    ),
                    reducer: IfLetStoreStore.reducer,
                    environment: .init(
                        accessToken: "fuga",
                        interactor: .init(networkService: StubNetworkService())
                    )
                )
            )
        }
    }
}
