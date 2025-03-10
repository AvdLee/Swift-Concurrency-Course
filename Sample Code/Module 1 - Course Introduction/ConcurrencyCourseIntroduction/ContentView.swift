//
//  ContentView.swift
//  ConcurrencyCourseIntroduction
//
//  Created by A.J. van der Lee on 19/02/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            DataRaceExample.dataRaceExample()
            DataRaceExample.dataRaceLockingExample()
        }
    }
}

#Preview {
    ContentView()
}
