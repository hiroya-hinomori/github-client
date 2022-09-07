//
//  LoadingView.swift
//  GithubClient
//
//  Created by 日野森 寛也（Hiroya Hinomori） on 2022/09/07.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    private let animation = Animation
        .linear(duration: 1)
        .repeatForever(autoreverses: false)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                Circle()
                    .trim(from: 0, to: 0.6)
                    .stroke(
                        AngularGradient(
                            gradient: .init(colors: [.blue, .white]),
                            center: .center
                        ),
                        style: .init(
                            lineWidth: 8,
                            lineCap: .round,
                            dash: [0.1, 16],
                            dashPhase: 8
                        )
                    )
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .onAppear() {
                        withAnimation(
                            Animation
                                .linear(duration: 1)
                                .repeatForever(autoreverses: false)
                        ) {
                            isAnimating = true
                        }
                    }
                    .onDisappear() {
                        isAnimating = false
                    }
            }
        }
    }
}

struct MaskView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .previewLayout(.sizeThatFits)
    }
}
