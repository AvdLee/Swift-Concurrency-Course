//
//  ThreadingDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 25/02/2025.
//

import Foundation

/*
 Demonstrates how Swift Concurrency uses threads by printing the current thread multiple times.
 
 Note: you need to set the project to Swift 5 language mode for this code example to work.
 Otherwise, you'll get an error:
 
 > Class property 'current' is unavailable from asynchronous contexts; Thread.current cannot be used from async contexts.
 
 */
struct ThreadingDemonstrator {
    private func firstTask() async throws {
        print("Task 1 started on thread: \(Thread.currentThread)")
        try await Task.sleep(for: .seconds(2))
        print("Task 1 resumed on thread: \(Thread.currentThread)")
    }

    private func secondTask() async {
        print("Task 2 started on thread: \(Thread.currentThread)")
    }

    func demonstrate() async {
        Task {
            try await firstTask()
        }
        Task {
            await secondTask()
        }
        
        await updateUI()
        
        Task(priority: .high) {
            await someImportantMethod()
        }
    }
    
    func someMethod() {
        // ...
    }
    
    private func someImportantMethod() async { }
    
    @MainActor
    private func updateUI() {
        /// Task inherits execution context from the `updateUI()` method.
        /// Since it's attribute with `@MainActor`, this task will run on the main thread.
        Task { @MainActor in
            print("Starting on the main thread: \(Thread.currentThread)")
            // Starting on the main thread: <_NSMainThread: 0x600001558000>{number = 1, name = main}

            /// Suspension point:
            /// - Main thread will be released for other work
            /// - This task will resume later when the background task completes.
            await someBackgroundTask()
            
            /// Returning on the main thread.
            print("Resuming on the main thread: \(Thread.currentThread)")
            // Resuming on the main thread: <_NSMainThread: 0x600001558000>{number = 1, name = main}
        }
    }

    /// There's no `@MainActor` attribute here, so this method will run on any of the available
    /// background threads.
    private func someBackgroundTask() async {
        print("Background task started on thread: \(Thread.currentThread)")
        // Background task started on thread: <NSThread: 0x600001553080>{number = 5, name = (null)}
    }
    
    func fetchData(completion: @escaping @Sendable (Result<String, Error>) -> Void) {
        let seconds = 1.0 // Simulating network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
            completion(.success("Data"))
        }
    }

    func loadData() {
        fetchData { result1 in
            switch result1 {
            case .success(let data1):
                fetchData { result2 in
                    switch result2 {
                    case .success(let data2):
                        fetchData { result3 in
                            switch result1 {
                            case .success(let data3):
                                fetchData { result2 in
                                    print("Finished loading: \(data1), \(data2), \(data3)")
                                }
                            case .failure:
                                print("Request 3 failed!")
                            }
                        }
                    case .failure:
                        print("Request 2 failed!")
                    }
                }
            case .failure:
                print("Request 1 failed!")
            }
        }
    }
    
    func fetchData() async throws -> String {
        try await Task.sleep(for: .seconds(1)) // Simulating network delay
        return "Data"
    }

    func loadData() async throws {
        let data1 = try await fetchData()
        let data2 = try await fetchData()
        let data3 = try await fetchData()
        
        print("Finished loading: \(data1), \(data2), \(data3)")
    }
}

extension Thread {
    /// This is a workaround for compiler error:
    /// Class property 'current' is unavailable from asynchronous contexts; Thread.current cannot be used from async contexts.
    /// See: https://github.com/swiftlang/swift-corelibs-foundation/issues/5139
    public static var currentThread: Thread {
        return Thread.current
    }
}
