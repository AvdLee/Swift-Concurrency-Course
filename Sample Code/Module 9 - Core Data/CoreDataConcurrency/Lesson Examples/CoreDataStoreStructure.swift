//
//  CoreDataStoreStructure.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import CoreData

nonisolated struct CoreDataStoreStructure {
    
    let viewContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    @CoreDataBackgroundContext
    func performHeavyQuery(closure: (NSManagedObjectContext) throws -> Void) rethrows {
        try closure(backgroundContext)
    }
    
    @MainActor
    func performWorkOnViewContext(closure: @escaping (NSManagedObjectContext) throws -> Void) async rethrows {
        try closure(viewContext)
    }
}
