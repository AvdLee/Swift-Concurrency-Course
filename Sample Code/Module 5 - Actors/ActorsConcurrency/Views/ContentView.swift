//
//  ContentView.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 25/03/2025.
//

import SwiftUI

struct ContentView: View {
    private let introductionToActorsDemonstrator = IntroductionToActorsDemonstrator()
    private let isolatedKeywordDemonstrator = IsolatedKeywordDemonstrator()
    private let actorReentrancyDemonstrator = ActorReentrancyDemonstrator()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await introductionToActorsDemonstrator.demonstrate()
        }
        .task {
            isolatedKeywordDemonstrator.demonstrate()
        }
        .task {
            await actorReentrancyDemonstrator.demonstrate()
        }
    }
}

#Preview {
    ContentView()
}
