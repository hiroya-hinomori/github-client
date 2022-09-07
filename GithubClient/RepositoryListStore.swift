//
//  RepositoryListStore.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/09/07.
//

import ComposableArchitecture
import Domain

enum RepositoryListStore {
    struct State: Equatable {
        struct AlertStatus: Equatable {
            static func == (lhs: RepositoryListStore.State.AlertStatus, rhs: RepositoryListStore.State.AlertStatus) -> Bool {
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

        var userName: String?
        var rows: IdentifiedArrayOf<Row> = []
        var selection: Identified<Row.ID, URL>?
        var alert: AlertStatus?
        var isShowIndicator = false
    }

    enum Action {
        case onAppear
        case onDisAppear
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
    
    enum Error: Swift.Error {
        case apiError
        case accessForbidden(name: String)
    }
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        enum CancelID {}
        switch action {
        case .onAppear:
            state.isShowIndicator = true
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
                return .task(operation: { .failure(.apiError) })
            }
        case let .fetchedRepositories(result):
            switch result {
            case let .success(list):
                let rows = list.reversed().map { State.Row(repository: $0, id: .init()) }
                state.rows = .init(uniqueElements: rows)
                state.isShowIndicator = false
            case let .failure(error):
                return .task(operation: { .failure(.apiError) })
            }
            return .none
        case let .setNavigation(.some(id)):
            if let target = state.rows.first(where: { $0.id == id }) {
                if target.repository.isPrivate {
                    return .task { .failure(.accessForbidden(name: target.repository.name)) }
                } else {
                    state.selection = .init(
                        target.repository.url,
                        id: id
                    )
                }
            }
            return .none
        case .setNavigation(.none):
            state.selection = nil
            return .none
        case .dismissAlert:
            state.alert = nil
            return .none
        case let .failure(error):
            state.isShowIndicator = false
            switch error {
            case .apiError:
                state.alert = .init(
                    state: .init(
                        title: .init("API ERROR"),
                        message: .init("Access Failed.")
                    )
                )
            case let .accessForbidden(name):
                state.alert = .init(
                    state: .init(
                        title: .init(name),
                        message: .init("This is Private repository.")
                    )
                )
            }
            return .none
        }
    }
}
