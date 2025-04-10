//
//  ContentView.swift
//  AsyncSequencesConcurrency
//
//  Created by A.J. van der Lee on 10/04/2025.
//

import SwiftUI

struct ContentView: View {
    
    private let asyncSequenceDemonstrator = AsyncSequenceDemonstrator()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await asyncSequenceDemonstrator.demonstrate()
        }
    }
}

#Preview {
    ContentView()
}
