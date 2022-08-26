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
    @State var isShowingAlert = false
  
    var body: some View {
        VStack {
            NavigationView {
                List(interactor.list.reversed(), id: \.url) { item in
                    if item.isPrivate {
                        ListItemView(repository: item)
                            .onTapGesture {
                                isShowingAlert = true
                            }
                    } else {
                        NavigationLink(destination: WebView(url: item.url)) {
                            ListItemView(repository: item)
                        }
                    }
                 }
                .navigationBarTitle(interactor.userName)
            }

        }
        .onAppear {
            interactor.fetchLoginUser(with: githubAccessToken)
        }
        .onReceive(interactor.$userName) { _ in
            interactor.fetchRepositories(with: githubAccessToken)
        }
        .alert(isPresented: self.$isShowingAlert) {
            Alert(title: .init("This repository is private."))
        }
    }

    struct ListItemView: View {
        let repository: Repositories.Repository

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Text(repository.name)
                        .font(.largeTitle)
                    Spacer()
                    Image(systemName: repository.isPrivate ? "lock" : "lock.open")
                        .frame(width: 30, height: 20, alignment: .center)
                }
                Text(repository.url.description)
                    .font(.caption)
            }
            .padding(.init(top: 5, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(githubAccessToken: "hoge", interactor: .init(networkService: StubNetworkService()))
    }
}
