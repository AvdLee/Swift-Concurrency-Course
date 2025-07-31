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
    private let customActorExecutorDemonstrator = CustomActorExecutorDemonstrator()
    private let isolatedDeinitDemonstrator = IsolatedDeinitDemonstrator()
    
    @State private var consoleLogsCapturer = ConsoleLogsCapturer()
    
    var body: some View {
        Form {
            Section(header: Text("Tap the button and look below for the print statements to learn")) {
                Button("Actor Introduction Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await introductionToActorsDemonstrator.demonstrate()
                    }
                }
                Button("Isolated Keyword Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    isolatedKeywordDemonstrator.demonstrate()
                }
                Button("Actor Reentrancy Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await actorReentrancyDemonstrator.demonstrate()
                    }
                }
                Button("Custom Actor Executor Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await customActorExecutorDemonstrator.demonstrate()
                    }
                }
                Button("Isolated Deinit Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    isolatedDeinitDemonstrator.demonstrate()
                }

            }
            Section("Console Output") {
                ConsoleLogsView(logs: consoleLogsCapturer.logs)
            }
        }.formStyle(.grouped)
    }
}

#Preview {
    ContentView()
}
