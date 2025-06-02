//
//  DetachedTasksDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

struct DetachedTasksDemonstrator {
    
    func detachedTaskPrintExample() async {
        await asyncPrint("Operation one")
        Task.detached {
            /// Runs the given nonthrowing operation asynchronously as part of a new top-level task.
            await asyncPrint("Operation two")
        }
        await asyncPrint("Operation three")

        // Prints:
        // Operation one
        // Operation three
        // Operation two
    }
    
    func detachedTaskCancellationExample() async {
        let outerTask = Task {
            /// This one will cancel.
            await longRunningAsyncOperation()

            /// This detached task won't cancel.
            Task.detached(priority: .background) {
                /// And, therefore, this task won't cancel either.
                await longRunningAsyncOperation()
            }
        }
        outerTask.cancel()
    }
    
    private func asyncPrint(_ string: String) async {
        print(string)
    }
    
    private func longRunningAsyncOperation() async {
        // Just a fake example method for the demonstration of detached tasks below.
    }
}
