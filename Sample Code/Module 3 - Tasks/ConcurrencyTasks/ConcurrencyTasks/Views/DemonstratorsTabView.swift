//
//  DemonstratorsTabView.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 13/03/2025.
//

import SwiftUI

struct DemonstratorsTabView: View {
    let cancelTaskDemonstrator = CancelTaskDemonstrator()
    let errorHandlingDemonstrator = ErrorHandlingDemonstrator()
    let detachedTasksDemonstrator = DetachedTasksDemonstrator()
    let threadingDemonstrator = ThreadingDemonstrator()
    let newThreadingDemonstrator = NewThreadingDemonstrator()
    let taskPriorityDemonstrator = TaskPriorityDemonstrator()

    @State private var consoleLogsCapturer = ConsoleLogsCapturer()

    var body: some View {
        Form {
            Section(header: Text("Tap the button and look below for the print statements to learn")) {
                Button("Cancel Task Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await cancelTaskDemonstrator.parentTaskCancelationExample()
                    }
                }

                Button("Error Handling Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await errorHandlingDemonstrator.throwingTaskExample()
                        await errorHandlingDemonstrator.nonthrowingTaskExample()
                        await errorHandlingDemonstrator.errorHandlingInTaskBodyExample()
                    }
                }

                Button("Detached Task Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await detachedTasksDemonstrator.detachedTaskPrintExample()
                        await detachedTasksDemonstrator.detachedTaskCancelationExample()
                    }
                }

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

                Button("Task Priority Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        taskPriorityDemonstrator.demonstrate()
                    }
                }
            }
            Section("Console Output") {
                ConsoleLogsView(logs: consoleLogsCapturer.logs)
            }
        }
    }
}
