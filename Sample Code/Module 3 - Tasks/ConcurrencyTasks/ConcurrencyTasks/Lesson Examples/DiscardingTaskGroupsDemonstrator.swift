//
//  Untitled.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 29/07/2025.
//

import Foundation
import UIKit

struct DiscardingTaskGroupsDemonstrator {
    enum Error: Swift.Error {
        case exampleErrorOne
        case exampleErrorTwo
    }
    func demonstrate() {
        Task {
            let numberOfTasksAdded = await withDiscardingTaskGroup(returning: Int.self) { group in
                group.addTask {
                    /// Perform some long running task without a return value.
                    print("Long running task completed")
                }
                
                /// While child tasks can't return a value, the group can.
                /// For example, you could return how many tasks you've added to the group.
                return 1
            }
            print("The discarding task group had \(numberOfTasksAdded) task(s) added.")
        }
        
        Task {
            do {
                try await withThrowingDiscardingTaskGroup { group in
                    group.addTask {
                        /// The first thrown error will be the error thrown to the outer task.
                        throw Error.exampleErrorOne
                    }
                    group.addTask {
                        try await Task.sleep(for: .seconds(1))
                        print("About to throw error two") // This line will never be reached.
                        throw Error.exampleErrorTwo
                    }
                }
            } catch {
                /// This will print `Error.exampleErrorOne`
                print("Discarding task group failed with error: \(error)")
            }
        }
        
        Task {
            do {
                /// An example of a child task that returns instead of re-throwing.
                try await withThrowingDiscardingTaskGroup { group in
                    group.addTask {
                        do {
                            try someNetworkCall()
                        } catch URLError.notConnectedToInternet {
                            /// You can return instead of throwing the error to the group,
                            /// preventing a cancellation of all group's child tasks.
                            print("Ingoring notConnectedToInternet network error")
                            return
                        }
                    }
                }
            } catch {
                print("Discarding task group failed with error: \(error)")
            }
        }
        
        Task {
            /// By default, the NotificationCenter API allows observing a single notification only.
            for await _ in NotificationCenter.default.notifications(named: UIApplication.didBecomeActiveNotification) {
                refreshData()
            }
            
            /// You can use a discarding task group to observe several ones together.
            await withDiscardingTaskGroup { group in
                group.addTask {
                    for await _ in NotificationCenter.default.notifications(named: UIApplication.didBecomeActiveNotification) {
                        refreshData()
                    }
                }
                
                group.addTask {
                    for await _ in NotificationCenter.default.notifications(named: .userDidLogin) {
                        refreshData()
                    }
                }
            }
            
            /// Even better would be to make use of the extension defined below on `NotificationCenter`.
            for await _ in NotificationCenter.default.notifications(named: [.userDidLogin, UIApplication.didBecomeActiveNotification]) {
                refreshData()
            }
        }
    }
    
    private func refreshData() {
        // Dummy method for sample code.
        print("Refreshing data!")
    }
    
    private func someNetworkCall() throws {
        // dummy method for sample code.
        throw URLError(.notConnectedToInternet)
    }
}

extension NotificationCenter {
    func notifications(named names: [Notification.Name]) -> AsyncStream<()> {
        AsyncStream { continuation in
            /// Create a task so we can cancel it on termination of the stream.
            let task = Task {
                /// Start the discarding task group.
                await withDiscardingTaskGroup { group in
                    /// Iterate over all names and add a child task to observe the notifications.
                    for name in names {
                        group.addTask {
                            for await _ in self.notifications(named: name) {
                                /// Yield to the stream to tell the observer one of the notifications was called.
                                continuation.yield(())
                            }
                        }
                    }
                }
                continuation.finish()
            }

            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
}

extension Notification.Name {
    static let userDidLogin: Notification.Name = .init("userDidLogin")
}
