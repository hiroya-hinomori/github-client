//
//  ContentView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/23.
//

import SwiftUI

struct ContentView: View {
    let token: String
    
    var body: some View {
        Text(token)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(token: "hoge")
    }
}
