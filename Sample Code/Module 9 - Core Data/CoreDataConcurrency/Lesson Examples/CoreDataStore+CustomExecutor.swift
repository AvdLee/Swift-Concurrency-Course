//
//  CoreDataStore.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import CoreData

actor CoreDataStoreCustomExecutor {
    
    static let shared = CoreDataStoreCustomExecutor()
    
    let persistentContainer: NSPersistentContainer
    
    nonisolated let modelExecutor: NSModelObjectContextExecutor
    
    nonisolated var unownedExecutor: UnownedSerialExecutor {
        modelExecutor.asUnownedSerialExecutor()
    }
    
    private var context: NSManagedObjectContext { modelExecutor.context }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataConcurrency")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        modelExecutor = NSModelObjectContextExecutor(context: persistentContainer.newBackgroundContext())
        
        Task {
            do {
                try await persistentContainer.loadPersistentStores()
            } catch {
                print("Failed to load persistent store: \(error)")
            }
        }
    }
    
    func deleteAllAndSave<T: NSManagedObject>(using fetchRequest: NSFetchRequest<T>) throws {
        let objects = try context.fetch(fetchRequest)
        for object in objects {
            context.delete(object)
        }
        try context.save()
    }
}
