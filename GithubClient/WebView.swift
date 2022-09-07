//
//  WebView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/08/26.
//

import SwiftUI
import WebKit
import ComposableArchitecture

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct TCAWebViewState: Equatable {
    var url: URL
}

enum TCAWebViewAction: Equatable {
    case browse
}

struct TCAWebViewEnvironment { }

let webViewReducer = Reducer<
    TCAWebViewState,
    TCAWebViewAction,
    TCAWebViewEnvironment
> { state, action, environment in
    switch action {
    case .browse:
        return .none
    }
}

struct TCAWebView: View {
    let store: Store<TCAWebViewState, TCAWebViewAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            WebView(url: viewStore.url)
        }
    }
    
}

struct TCAWebView_Previews: PreviewProvider {
    static var previews: some View {
        TCAWebView(
            store: .init(
                initialState: .init(url: .init(string: "https://yahoo.co.jp")!),
                reducer: webViewReducer,
                environment: .init()
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
