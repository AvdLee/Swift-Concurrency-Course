//
//  NewThreadingDemonstrator.swift
//  ConcurrencyThreading
//
//  Created by A.J. van der Lee on 06/05/2025.
//

import Foundation

/// Note: This demonstrates how Swift 6.2 will work with threading.
/// Enable this today with upcoming feature flag `AsyncCallerExecution`.
/// See: https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
@MainActor
struct NewThreadingDemonstrator {
    
    func demonstrate() async {
        print("Starting on the main thread: \(Thread.currentThread)")
        // Prints: Starting on the main thread: <_NSMainThread: 0x6000006b4040>{number = 1, name = main}

        let notSendable = NotSendable()
        await notSendable.performAsync()
        
        /// Returning on the main thread.
        print("Resuming on the main thread: \(Thread.currentThread)")
        // Prints: Resuming on the main thread: <_NSMainThread: 0x6000006b4040>{number = 1, name = main}
    }
}

class NotSendable {

    func performAsync() async {
        print("Task started on thread: \(Thread.currentThread)")
        // Old situation: Task started on thread: <NSThread: 0x600003694d00>{number = 8, name = (null)}
        // New situation: Task started on thread: <_NSMainThread: 0x6000006b4040>{number = 1, name = main}
    }
}
