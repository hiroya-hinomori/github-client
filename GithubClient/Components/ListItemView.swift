//
//  ListItemView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/26.
//

import Domain
import SwiftUI

struct ListItemView<V: View>: View {
    struct Repository: RepositoryType, Hashable {
        var url: URL
        var name: String
        var isPrivate: Bool
    }
    
    let repository: Repository
    let destination: V
    
    @State private var isShowingAlert = false
    @State private var openRepository: Repository?

    var body: some View {
        NavigationLink(
            destination: destination,
            tag: repository,
            selection: $openRepository
        ) {
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
        .alert(
            isPresented: $isShowingAlert,
            content: {
                .init(
                    title: .init(repository.name),
                    message: .init("This repository is Private🔐")
                )
            })
        .onTapGesture {
            if repository.isPrivate {
                isShowingAlert = true
            } else {
                openRepository = repository
            }
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(
            repository: .init(
                url: .init(string: "https://hogehoge.co.jp")!,
                name: "hoge-jiro",
                isPrivate: true
            ),
            destination: Text("hoge"))
        ListItemView(
            repository: .init(
                url: .init(string: "https://hogehoge.co.jp")!,
                name: "hoge-saburo",
                isPrivate: false
            ),
            destination: Text("hoge"))
    }
}
