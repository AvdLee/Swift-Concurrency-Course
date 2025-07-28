//
//  CoreDataStore.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import CoreData

nonisolated struct CoreDataStore {
    
    static let shared = CoreDataStore()
    
    let persistentContainer: NSPersistentContainer
    private var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataConcurrency")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        Task { [persistentContainer] in
            do {
                try await persistentContainer.loadPersistentStores()
            } catch {
                print("Failed to load persistent store: \(error)")
            }
        }
    }
    
    @MainActor
    func perform(_ block: (NSManagedObjectContext) throws -> Void) rethrows {
        try block(viewContext)
    }
    
    @concurrent func deleteAllAndSave<T: NSManagedObject>(using fetchRequest: NSFetchRequest<T>) async throws {
        let backgroundContext = persistentContainer.newBackgroundContext()
        try await backgroundContext.perform {
            let objects = try backgroundContext.fetch(fetchRequest)
            for object in objects {
                backgroundContext.delete(object)
            }
            try backgroundContext.save()
        }
    }
}
