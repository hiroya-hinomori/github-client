//
//  RootView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/26.
//

import ComposableArchitecture
import SwiftUI
import Domain

struct RootState: Equatable {
    static func == (lhs: RootState, rhs: RootState) -> Bool {
        return lhs.userName == rhs.userName &&
        lhs.repositoryList.count == rhs.repositoryList.count
    }
    
    var userName: String
    var repositoryList: [RepositoryType]
}

enum RootAction {
    case viewDidAppear
    case fetchedUserName(TaskResult<String>)
    case fetchedRepositories(TaskResult<[RepositoryType]>)
}

struct RootEnvironment {
    let accessToken: String
    let interactor: Interactor
}

let rootReducer = Reducer<
    RootState,
    RootAction,
    RootEnvironment
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
    }
}

struct RootView: View {
    let store: Store<RootState, RootAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                ForEach(
                    viewStore.repositoryList.reversed(),
                    id: \.url
                ) { repository in
                    ListItemView(repository: repository)
                        .onTapGesture {
                            print(repository.name)
                        }
                }
            }
            .onAppear {
                viewStore.send(.viewDidAppear)
            }
        }
    }

}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: .init(
                initialState: .init(
                    userName: "hoge",
                    repositoryList: []
                ),
                reducer: rootReducer,
                environment: .init(
                    accessToken: "fuga",
                    interactor: .init(networkService: StubNetworkService())
                )
            )
        )
    }
}
