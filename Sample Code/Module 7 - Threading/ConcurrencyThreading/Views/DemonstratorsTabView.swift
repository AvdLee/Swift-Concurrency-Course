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
            }
            Section("Console Output") {
                ConsoleLogsView(logs: consoleLogsCapturer.logs)
            }
        }
    }
}
