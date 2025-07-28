//
//  CoreDataBackgroundContextGlobalActor.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import CoreData

@globalActor
actor CoreDataBackgroundContext {
    static let shared = CoreDataBackgroundContext()
    
    nonisolated let modelExecutor: NSModelObjectContextExecutor
    
    nonisolated var unownedExecutor: UnownedSerialExecutor {
        modelExecutor.asUnownedSerialExecutor()
    }
    
    init() {
        let backgroundContext = CoreDataStore.shared.persistentContainer.newBackgroundContext()
        modelExecutor = NSModelObjectContextExecutor(context: backgroundContext)
    }
}
