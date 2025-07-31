//
//  CustomActorExecutor.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 01/04/2025.
//

import Foundation

private final class DispatchQueueSerialExecutor: SerialExecutor {
    private let dispatchQueue: DispatchQueue
    
    init(dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
    }
    
    func enqueue(_ job: consuming ExecutorJob) {
        let unownedJob = UnownedJob(job)
        let unownedExecutor = asUnownedSerialExecutor()
        
        dispatchQueue.async {
            unownedJob.runSynchronously(on: unownedExecutor)
        }
    }
}

private actor SerialLoggingActor {
    private let executor: DispatchQueueSerialExecutor
    
    nonisolated var unownedExecutor: UnownedSerialExecutor {
        executor.asUnownedSerialExecutor()
    }
    
    init(dispatchQueue: DispatchQueue) {
        executor = DispatchQueueSerialExecutor(dispatchQueue: dispatchQueue)
    }
    
    func log(_ message: String) {
        print("[\(Thread.currentThread), Queue: \(Thread.queueLabel)] \(message)")
    }
}

private actor SharedExecutorLoggingActor {
    nonisolated var unownedExecutor: UnownedSerialExecutor {
        DispatchQueueSerialExecutor.loggingExecutor.asUnownedSerialExecutor()
    }
    
    func log(_ message: String) {
        print("[\(Thread.currentThread), Queue: \(Thread.queueLabel)] \(message)")
    }
}

extension DispatchQueueSerialExecutor {
    
    /// An example of a globally available executor to use inside any actor.
    static let loggingExecutor = DispatchQueueSerialExecutor(dispatchQueue: DispatchQueue(label: "com.logger.queue", qos: .utility))
}

private final class DispatchQueueTaskExecutor: TaskExecutor {
    private let dispatchQueue: DispatchQueue
    
    init(dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
    }
    
    func enqueue(_ job: consuming ExecutorJob) {
        let unownedJob = UnownedJob(job)
        let unownedExecutor = asUnownedTaskExecutor()
        print("Enqueue job inside DispatchQueueTaskExecutor")
        dispatchQueue.async {
            unownedJob.runSynchronously(on: unownedExecutor)
        }
    }
}

private final class DispatchQueueTaskSerialExecutor: TaskExecutor, SerialExecutor {
    private let dispatchQueue: DispatchQueue
    
    init(dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
    }
    
    func enqueue(_ job: consuming ExecutorJob) {
        let unownedJob = UnownedJob(job)
        dispatchQueue.async {
            unownedJob.runSynchronously(
                isolatedTo: self.asUnownedSerialExecutor(),
                taskExecutor: self.asUnownedTaskExecutor()
            )
        }
    }
    
    func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        UnownedSerialExecutor(ordinary: self)
    }

    func asUnownedTaskExecutor() -> UnownedTaskExecutor {
        UnownedTaskExecutor(ordinary: self)
    }
}

struct CustomActorExecutorDemonstrator {
    @MainActor
    func demonstrate() async {
        let dispatchQueue = DispatchQueue(label: "com.logger.queue", qos: .utility)
        dispatchQueue.sync {
            /// Give the thread a name so we can verify it in our print statements.
            Thread.current.name = "Logging Queue"
        }
        let actor = SerialLoggingActor(dispatchQueue: dispatchQueue)
        await actor.log("Example message")

        // Prints: [<NSThread: 0x60000062c980>{number = 2, name = Logging Queue}] Example message

        let taskExecutor = DispatchQueueTaskExecutor(dispatchQueue: dispatchQueue)

        Task(executorPreference: taskExecutor) {
            print("[\(Thread.currentThread), Queue: \(Thread.queueLabel)] Task Executor example")
            
            // Prints: [<NSThread: 0x60000062c980>{number = 2, name = Logging Queue}] Task Executor example
        }
    }
}

extension Thread {
    /// This is a workaround for compiler error:
    /// Class property 'current' is unavailable from asynchronous contexts; Thread.current cannot be used from async contexts.
    /// See: https://github.com/swiftlang/swift-corelibs-foundation/issues/5139
    nonisolated static var currentThread: Thread {
        return Thread.current
    }
    
    /// Returns the label you assigned to the dispatch queue at creation time. Should only be used for demo purposes and not in production code.
    static var queueLabel: String {
        let name = __dispatch_queue_get_label(nil)
        guard let label = String(cString: name, encoding: .utf8) else { return "" }
        return label
    }
}
