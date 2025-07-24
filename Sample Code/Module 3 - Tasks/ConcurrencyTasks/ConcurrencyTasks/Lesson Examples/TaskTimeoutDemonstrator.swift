//
//  TaskTimeoutDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/07/2025.
//

import Foundation

enum TaskTimeoutError: Error, CustomDebugStringConvertible {
    case timeout
    case missingValue
    
    var debugDescription: String {
        switch self {
        case .timeout:
            return "Task timed out"
        case .missingValue:
            return "Task returned nil"
        }
    }
}

struct TaskTimeoutDemonstrator {
    func demonstrateTaskInitializer() async {
        do {
            /// Create a task with a timeout.
            /// Note the new `timeout` property:
            let timeoutTask = Task(name: "Task with timeout", timeout: .seconds(1)) {
                /// Sleep for longer than the timeout to demonstrate the task timing out.
                try await Task.sleep(for: .seconds(2))
                
                return "Did not timeout"
            }
            let output = try await timeoutTask.value
            print(output) // Will never be reached in this demo.
        } catch {
            print("Task failed with error: \(error)")
        }
    }
}

extension Task where Failure == any Error {
    
    @discardableResult
    init<C>(
        name: String? = nil,
        priority: TaskPriority? = nil,
        
        /// New: a timeout property to configure how long a task may perform before failing with a timeout error.
        timeout: C.Instant.Duration,
        clock: C = .continuous,
        operation: @Sendable @escaping @isolated(any) () async throws -> Success
    ) where C : Clock {
        self = Task(name: name, priority: priority, operation: {
            try await withThrowingTaskGroup { group in
                
                /// Add the operation to perform as the first task.
                _ = group.addTaskUnlessCancelled {
                    try await operation()
                }
                
                /// Add another task to trigger the timeout if it finishes earlier than our first task.
                _ = group.addTaskUnlessCancelled { () -> Success in
                    try await Task<Never, Never>.sleep(for: timeout, clock: clock)
                    throw TaskTimeoutError.timeout
                }
                
                /// We need to deal with an optional, even though we know it's not optional.
                /// This is default for task groups to account for when there aren’t any pending tasks.
                /// Awaiting on an empty group immediately returns `nil` without suspending.
                guard let result = try await group.next() else {
                    throw TaskTimeoutError.missingValue
                }
                
                /// If we reach this, it means we have a value before the timeout.
                /// We cancel the group, which means just cancelling the timeout task.
                group.cancelAll()
                return result
            }
        })
    }
}

extension TaskTimeoutDemonstrator {
    func demonstrateGlobalTimeoutFunction() async {
        do {
            /// Using the global defined method `withTaskTimeoutHandler` to trigger a timeout if the inner operation
            /// does not complete before our timeout.
            let output = try await withTaskTimeoutHandler(timeout: .seconds(1), operation: {
                /// Sleep for longer than the timeout to demonstrate the task timing out.
                try await Task.sleep(for: .seconds(2))
                
                return "Task completed before timeout"
            }, onTimeout: {
                return "Timeout fallback message: Task did timeout"
            })

            print("Result of global timeout function: \(output)")
        } catch {
            print("Global timeout function failed with error: \(error)")
        }
    }
}

func withTaskTimeoutHandler<Success: Sendable>(
    timeout: Duration,
    operation: @Sendable @escaping () async throws -> Success,
    onTimeout handler: @Sendable @escaping () throws -> Success,
    isolation: isolated (any Actor)? = #isolation
) async rethrows -> Success {
    try await withThrowingTaskGroup(returning: Success.self) { group in
        
        /// Add the operation to perform as the first task.
        _ = group.addTaskUnlessCancelled {
            try await operation()
        }
        
        /// Add another task to trigger the timeout handler if it finishes earlier than our first task.
        _ = group.addTaskUnlessCancelled { () -> Success in
            try await Task<Never, Never>.sleep(for: timeout, clock: .continuous)
            return try handler()
        }
        
        /// We need to deal with an optional, even though we know it's not optional.
        /// This is default for task groups to account for when there aren’t any pending tasks.
        /// Awaiting on an empty group immediately returns `nil` without suspending.
        guard let result = try await group.next() else {
            throw TaskTimeoutError.missingValue
        }
        
        /// If we reach this, it means we have a value before the timeout.
        /// We cancel the group, which means just cancelling the timeout task.
        group.cancelAll()
        return result
    }
}
