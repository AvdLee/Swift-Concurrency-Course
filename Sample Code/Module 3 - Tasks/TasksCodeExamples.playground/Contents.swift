import UIKit

final class SomeTaskExecutor {
    
    var currentTask: Task<Void, Never>?
    
    func execute() {
        /// Store a reference to the task.
        currentTask = Task {
            await someAsynchronousMethod()
        }
    }
    
    deinit {
        /// Cancel the task when the outer instance is being deinitialized.
        currentTask?.cancel()
    }
}

func someSynchronousMethod() {
    Task {
        await someAsynchronousMethod()
    }
}

func someAsynchronousMethod() async {
    
}
