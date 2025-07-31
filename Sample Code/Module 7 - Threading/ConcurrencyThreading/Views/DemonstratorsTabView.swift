//
//  DemonstratorsTabView.swift
//  ConcurrencyThreading
//
//  Created by A.J. van der Lee on 06/05/2025.
//

import SwiftUI

struct DemonstratorsTabView: View {
    let threadingDemonstrator = ThreadingDemonstrator()
    let newThreadingDemonstrator = NewThreadingDemonstrator()
    let actorReentrancyDemonstrator = ActorReentrancyDemonstrator()
    
    @State private var consoleLogsCapturer = ConsoleLogsCapturer()

    var body: some View {
        Form {
            Section(header: Text("Tap the button and look below for the print statements to learn")) {
                Button("Threading Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await threadingDemonstrator.demonstrate()
                    }
                }
                
                Button("New Threading Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await newThreadingDemonstrator.demonstrate()
                    }
                }
                Button("Actor Reentrancy Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    actorReentrancyDemonstrator.demonstrate()
                }
            }
            Section("Console Output") {
                ConsoleLogsView(logs: consoleLogsCapturer.logs)
            }
        }
        .task(priority: .high, {
            /// Executes earlier than a task scheduled inside `onAppaer`.
            print("1")
        })
        .onAppear {
            /// Scheduled later than using the `task` modifier which
            /// adds an asynchronous task to perform before the view appears.
            Task(priority: .high) { print("2") }
            
            /// Regular code inside `onAppear` might appear to run earlier than a `Task`.
            /// This is due to the task executor scheduler.
            print("3")
        }
    }
}
