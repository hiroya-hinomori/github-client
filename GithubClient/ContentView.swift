//
//  ContentView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/23.
//

import SwiftUI
import Domain

struct ContentView: View {
    let githubAccessToken: String
    @ObservedObject var interactor: Interactor
    
    var body: some View {
        VStack {
            Text(interactor.userName)
                .padding()
            List(interactor.list, id: \.url) {
                ListItemView(repository: $0)
            }
        }
        .onAppear {
            interactor.fetchLoginUser(with: githubAccessToken)
        }
        .onReceive(interactor.$userName) { _ in
            interactor.fetchRepositories(with: githubAccessToken)
        }
    }
    
    struct ListItemView: View {
        let repository: Repositories.Repository

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(repository.name)
                    .font(.largeTitle)
                Text(repository.url.description)
                    .font(.caption)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(githubAccessToken: "hoge", interactor: .init(networkService: NetworkService()))
    }
}
