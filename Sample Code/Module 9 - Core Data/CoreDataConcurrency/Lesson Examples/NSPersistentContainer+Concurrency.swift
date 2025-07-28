//
//  NSPersistentContainer+Concurrency.swift
//  CoreDataConcurrency
//
//  Created by A.J. van der Lee on 28/07/2025.
//

import CoreData

extension NSPersistentContainer {
    func loadPersistentStores() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.loadPersistentStores { storeDescription, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
