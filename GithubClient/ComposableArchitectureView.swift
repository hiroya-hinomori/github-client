//
//  ComposableArchitectureView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/30.
//

import ComposableArchitecture
import SwiftUI
import Domain

struct ComposableArchitectureState: Equatable {
    static func == (lhs: ComposableArchitectureState, rhs: ComposableArchitectureState) -> Bool {
        return lhs.userName == rhs.userName &&
        lhs.repositoryList.count == rhs.repositoryList.count
    }
    
    var userName: String
    var repositoryList: [RepositoryType]
    var selectionRepository: RepositoryType?
    var alert: AlertState<ComposableArchitectureAction>?
}

enum ComposableArchitectureAction {
    case viewDidAppear
    case browse
    case fetchedUserName(TaskResult<String>)
    case fetchedRepositories(TaskResult<[RepositoryType]>)
    case setNavigation(URL?)
    case dismissAlert
}

struct ComposableArchitectureEnvironment {
    let accessToken: String
    let interactor: Interactor
}

let composableArchitectureReducer = Reducer<
    ComposableArchitectureState,
    ComposableArchitectureAction,
    ComposableArchitectureEnvironment
> { state, action, environment in
    switch action {
    case .viewDidAppear:
        return .task {
            await .fetchedUserName(TaskResult {
                try await environment
                    .interactor
                    .fetchAsyncLoginUser(with: environment.accessToken)
            })
        }
    case .browse:
        return .none
    case .fetchedUserName(let result):
        switch result {
        case .success(let value):
            state.userName = value
            return .task {
                await .fetchedRepositories(
                    .init(catching: {
                        try await environment
                            .interactor
                            .fetchAsyncRepositories(with: environment.accessToken)
                    })
                )
            }
        case .failure(let error):
            print(error)
        }
        return .none
    case .fetchedRepositories(let result):
        switch result {
        case .success(let list):
            state.repositoryList = list
        case .failure(let error):
            print(error)
        }
        return .none
    case .setNavigation(let url):
        if let targetRepository = state.repositoryList.first(where: { $0.url == url }) {
            if targetRepository.isPrivate {
                state.alert = .init(
                    title: .init(targetRepository.name),
                    message: .init("This is Private repository."),
                    dismissButton: .cancel(.init("OK"))
                )
            } else {
                state.selectionRepository = targetRepository
            }
        }
        return .none
    case .dismissAlert:
        state.alert = nil
        return .none
    }
}

struct ComposableArchitectureView: View {
    let store: Store<ComposableArchitectureState, ComposableArchitectureAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                ForEach(
                    viewStore.repositoryList.reversed(),
                    id: \.url
                ) { repository in
                    NavigationLink(
                        destination: WebView(url: repository.url),
//                        destination: IfLetStore(
//                          self.store.scope(
//                            state: \.selectionRepository?.url
//                            action: RootAction.browse
//                          )
//                        ) { _ in
//                            WebView(url: repository.url)
//                        },
                        tag: repository.url,
                        selection: viewStore.binding(
                            get: \.selectionRepository?.url,
                            send: ComposableArchitectureAction.setNavigation(_:)
                        )
                    ) {
                        ListItemView(repository: repository)
                    }
                }
                .navigationTitle(viewStore.userName)
            }
            .onAppear {
                viewStore.send(.viewDidAppear)
            }
            .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
        }
    }

}

struct ComposableArchitectureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComposableArchitectureView(
                store: .init(
                    initialState: .init(
                        userName: "hoge",
                        repositoryList: []
                    ),
                    reducer: composableArchitectureReducer,
                    environment: .init(
                        accessToken: "fuga",
                        interactor: .init(networkService: StubNetworkService())
                    )
                )
            )
        }
    }
}
