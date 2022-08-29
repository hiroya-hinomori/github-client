//
//  ListItemView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/26.
//

import Domain
import SwiftUI

struct ListItemView: View {
    let repository: RepositoryType

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

struct ListItemView_Previews: PreviewProvider {
    struct Mock: RepositoryType {
        var url: URL
        var name: String
        var isPrivate: Bool
    }
    
    static var previews: some View {
        ListItemView(repository: Mock(url: .init(string: "https://hogehoge.co.jp")!, name: "hoge-jiro", isPrivate: true))
        ListItemView(repository: Mock(url: .init(string: "https://hogehoge.co.jp")!, name: "hoge-saburo", isPrivate: false))
    }
}
