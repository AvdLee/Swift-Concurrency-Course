//
//  MutexExamples.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 15/07/2025.
//

import Synchronization
import Foundation

/// A non-Sendable example since `searchHistory` is mutable without a synchronization solution in place.
final class SearchHistoryNonSendable {
    var searchHistory = [String]()
}

/// A `Sendable` example since we synchronized access to `searchHistory` using a mutex.
final class SearchHistory: Sendable {
    private let searchHistory = Mutex<[String]>([])
    
    var currentHistory: [String] {
        searchHistory.withLock { $0 }
    }
    
    func storeSearchQuery(_ query: String) {
        searchHistory.withLock { history in
            history.append(query)
        }
    }
}

/// A classic example: a thread-safe counter using Swift's Mutex.
final class Counter {
    
    enum Error: Swift.Error {
        case reachedZero
    }
    
    /// Use the Mutex to protect the count value.
    private let count = Mutex<Int>(0)
    
    /// Provide a public accessor to read the current count value.
    var currentCount: Int {
        count.withLock { currentCount in
            return currentCount
        }
    }
    
    func increment() {
        count.withLock { currentCount in
            currentCount += 1
        }
    }
    
    func decrement() throws {
        try count.withLock { currentCount in
            guard currentCount > 0 else {
                throw Error.reachedZero
            }
            currentCount -= 1
        }
    }
}
