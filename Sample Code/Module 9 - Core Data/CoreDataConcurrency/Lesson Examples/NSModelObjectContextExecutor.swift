//
//  NSModelObjectContextExecutor.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import CoreData

final class NSModelObjectContextExecutor: @unchecked Sendable, SerialExecutor {

    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func enqueue(_ job: consuming ExecutorJob) {
        let unownedJob = UnownedJob(job)
        let unownedExecutor = asUnownedSerialExecutor()
        
        /// Execute the enqueued job on the configured managed object context.
        context.perform {
            unownedJob.runSynchronously(on: unownedExecutor)
        }
    }
    
    func asUnownedSerialExecutor() -> UnownedSerialExecutor {
        UnownedSerialExecutor(ordinary: self)
    }
}
