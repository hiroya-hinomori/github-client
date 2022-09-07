//
//  HomeBuilder.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/09/05.
//

import ComposableArchitecture
import Domain

enum IfLetStoreStore {
    struct State: Equatable {
        struct AlertStatus: Equatable {
            static func == (lhs: IfLetStoreStore.State.AlertStatus, rhs: IfLetStoreStore.State.AlertStatus) -> Bool {
                lhs.state.id == rhs.state.id
            }
            
            let state: AlertState<Action>
        }

        struct Row: Equatable, Identifiable {
            static func == (lhs: State.Row, rhs: State.Row) -> Bool {
                return lhs.id == rhs.id
            }
            
            var repository: RepositoryType
            let id: UUID
        }

        var userName: String = ""
        var rows: IdentifiedArrayOf<Row> = []
        var selection: Identified<Row.ID, TCAWebViewState>?
        var alert: AlertStatus?
    }

    enum Action {
        case onAppear
        case onDisAppear
        case browse(TCAWebViewAction)
        case fetchedUserName(TaskResult<String>)
        case fetchedRepositories(TaskResult<[RepositoryType]>)
        case setNavigation(id: UUID?)
        case dismissAlert
        case failure(Error)
    }

    struct Environment {
        let accessToken: String
        let interactor: Interactor
    }

    static let reducer =
        webViewReducer
        .pullback(
            state: \Identified.value,
            action: .self,
            environment: { $0 }
        )
        .optional()
        .pullback(
            state: \State.selection,
            action: /Action.browse,
            environment: { _ in TCAWebViewEnvironment() }
        )
        .combined(
            with: Reducer<
                State, Action, Environment
            > { state, action, environment in
                enum CancelID {}
                switch action {
                case .onAppear:
                    return .task {
                        await .fetchedUserName(.init {
                            try await environment
                                .interactor
                                .fetchAsyncLoginUser(with: environment.accessToken)
                        })
                    }
                    .cancellable(id: CancelID.self, cancelInFlight: true)
                case .onDisAppear:
                    return .cancel(id: CancelID.self)
                case let .fetchedUserName(result):
                    switch result {
                    case .success(let value):
                        state.userName = value
                        return .task {
                            await .fetchedRepositories(.init {
                                try await environment
                                    .interactor
                                    .fetchAsyncRepositories(with: environment.accessToken)
                            })
                        }
                        .cancellable(id: CancelID.self, cancelInFlight: true)
                    case let .failure(error):
                        return .task(operation: { .failure(error) })
                    }
                case let .fetchedRepositories(result):
                    switch result {
                    case let .success(list):
                        let rows = list.reversed().map { State.Row(repository: $0, id: .init()) }
                        state.rows = .init(uniqueElements: rows)
                    case let .failure(error):
                        return .task(operation: { .failure(error) })
                    }
                    return .none
                case let .setNavigation(.some(id)):
                    guard let target = state.rows[id: id] else { return .none }
                    if target.repository.isPrivate {
                        state.alert = .init(
                            state: .init(
                                title: .init(target.repository.name),
                                message: .init("This is Private repository.")
                            )
                        )
                    } else {
                        state.selection = .init(
                            .init(url: target.repository.url),
                            id: id
                        )
                    }
                    return .none
                case .setNavigation(.none):
                    state.selection = nil
                    return .none
                case .dismissAlert:
                    state.alert = nil
                    return .none
                case .browse, .failure:
                    return .none
                }
            }
        )

}
