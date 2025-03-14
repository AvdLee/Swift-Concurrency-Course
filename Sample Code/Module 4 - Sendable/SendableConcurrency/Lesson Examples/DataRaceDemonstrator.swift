//
//  DataRaceDemonstrator.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 14/03/2025.
//

import Foundation

struct DataRaceDemonstrator {
    
    /// When the Thread Sanitizer in the scheme settings is turned on, this method will result in a purple warning for a data race in closure #1.
    func demonstrateDataRace() {
        var counter = 0
        let queue = DispatchQueue.global(qos: .background)
        
        for _ in 1...10 {
            queue.async {
                // Data race potential: multiple threads access without synchronization:
                counter += 1
            }
        }
        
        // Reading the value while it's written.
        print("Final counter value: \(counter)")
    }
    
    /// By using a serial queue, we synchronize access to the counter property and prevent any data races from occuring.
    func demonstrateSynchronizedGCDDataRaceFix() {
        var counter = 0
        let serialQueue = DispatchQueue(label: "com.example.serial")

        for _ in 1...10 {
            serialQueue.async {
                counter += 1
            }
        }

        serialQueue.async {
            print("Final counter value: \(counter)")
        }
    }
    
    func demonstrateConcurrencyActorDataRaceFix() async {
        let counter = Counter()

        for _ in 1...10 {
            await counter.increment() // Safely increments the counter
        }

        /// Safe read using `await`
        print("Final counter value: \(await counter.getValue())")
    }
    
    func demonstrateRaceCondition() async {
        let counter = Counter()

        for _ in 1...10 {
            Task {
                await counter.increment() // Safely increments the counter
            }
        }

        /// Safe read using `await`
        print("Final counter value: \(await counter.getValue())")
    }
}

private actor Counter {
    private var value = 0
    
    func increment() {
        value += 1
    }
    
    func getValue() -> Int {
        return value
    }
}
