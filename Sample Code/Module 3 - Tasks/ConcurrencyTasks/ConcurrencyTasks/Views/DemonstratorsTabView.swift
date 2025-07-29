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
    let taskPriorityDemonstrator = TaskPriorityDemonstrator()
    let taskGroupsDemonstrator = TaskGroupsDemonstrator()
    let taskTimeoutDemonstrator = TaskTimeoutDemonstrator()
    let discardingTaskGroupsDemonstrator = DiscardingTaskGroupsDemonstrator()
    
    @State private var consoleLogsCapturer = ConsoleLogsCapturer()

    var body: some View {
        Form {
            Section(header: Text("Tap the button and look below for the print statements to learn")) {
                Button("Cancel Task Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await cancelTaskDemonstrator.parentTaskCancellationExample()
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

                Button("Detached Task Print Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await detachedTasksDemonstrator.detachedTaskPrintExample()
                    }
                }
                
                Button("Detached Task Cancellation Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await detachedTasksDemonstrator.detachedTaskCancellationExample()
                    }
                }

                Button("Task Priority Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        taskPriorityDemonstrator.demonstrate()
                    }
                }
                
                Button("Task Group Error Propagation Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await taskGroupsDemonstrator.errorPropagation()
                    }
                }
                Button("Task Initializer Timeout Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await taskTimeoutDemonstrator.demonstrateTaskInitializer()
                    }
                }
                Button("Global Timeout Function Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    Task {
                        await taskTimeoutDemonstrator.demonstrateGlobalTimeoutFunction()
                    }
                }
                Button("Discarding Task Group Demonstration") {
                    consoleLogsCapturer.clearLogs()
                    discardingTaskGroupsDemonstrator.demonstrate()
                }
            }
            Section("Console Output") {
                ConsoleLogsView(logs: consoleLogsCapturer.logs)
            }
        }
    }
}
