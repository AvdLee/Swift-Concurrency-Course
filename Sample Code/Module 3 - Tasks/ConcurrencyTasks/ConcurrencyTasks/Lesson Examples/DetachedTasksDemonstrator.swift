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
    
    private func asyncPrint(_ string: String) async {
        print(string)
    }
    
    func detachedTaskCancellationExample() async {
        let outerTask = Task {
            /// This one will cancel.
            print("Start longRunningAsyncOperation 1")
            await longRunningAsyncOperation()

            /// This detached task won't cancel.
            Task.detached(priority: .background) {
                try Task.checkCancellation()

                /// And, therefore, this task won't cancel either.
                print("Start longRunningAsyncOperation 2")
                await longRunningAsyncOperation()
            }
        }
        outerTask.cancel()
    }

    /// Faking a long running task by using a `Task.sleep`
    private func longRunningAsyncOperation() async {
        do {
            try await Task.sleep(for: .seconds(5))
        } catch {
            print("\(#function) failed with error: \(error)")
        }
    }
}
