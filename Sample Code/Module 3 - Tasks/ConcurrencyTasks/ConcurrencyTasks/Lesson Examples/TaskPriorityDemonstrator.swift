//
//  TaskPriorityDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 13/03/2025.
//

struct TaskPriorityDemonstrator {
    func demonstrate() {
        Task {
            print("Default task priority: \(Task.currentPriority)")
        }
        Task.detached {
            print("Default task priority: \(Task.currentPriority)")
            // Default task priority: TaskPriority.medium
        }
        Task(priority: .background) {
            print("This task runs with a background priority: \(Task.currentPriority)")
            // This task runs with a background priority: TaskPriority.background
        }
        Task(priority: .high) {
            async let taskPriority = getCurrentTaskPriority()
            print("Async let executed with priority: \(await taskPriority)")
            // Prints: Async let executed with priority: TaskPriority.high
        }
        Task(priority: .high) {
            await printDetachedTaskPriority()
        }
    }
    
    func printDetachedTaskPriority() async {
        print("Current task priority: \(Task.currentPriority)")
        // Prints: Current task priority: TaskPriority.high

        Task.detached {
            print("Detached task priority: \(Task.currentPriority)")
            // Prints: Detached task priority: TaskPriority.medium
        }
    }
    
    func getCurrentTaskPriority() -> TaskPriority {
        return Task.currentPriority
    }
}
