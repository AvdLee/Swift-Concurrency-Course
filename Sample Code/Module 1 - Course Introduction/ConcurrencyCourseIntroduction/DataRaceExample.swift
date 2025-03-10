//
//  DataRaceExample.swift
//  ConcurrencyCourseIntroduction
//
//  Created by A.J. van der Lee on 05/03/2025.
//

import Foundation

struct DataRaceExample {
    static func dataRaceExample() {

        var counter = 0

        let queue = DispatchQueue.global(qos: .background)

        for _ in 1...10 {
            queue.async {
                // Data race potential: multiple threads modifying `counter` without synchronization
                counter += 1
            }
        }

        // Give some time for async tasks to complete.
        sleep(1)

        // Read the value while it's still being written.
        print("Final counter value: \(counter)")
    }
    
    static func dataRaceLockingExample() {
        var counter = 0
        let serialQueue = DispatchQueue(label: "com.example.serial")

        for _ in 1...10 {
            serialQueue.async {
                counter += 1
            }
        }

        sleep(1)

        serialQueue.async {
            print("Final counter value: \(counter)")
        }
    }
    
    static func dataRaceConcurrenyExample() {
        let counter = Counter()

        Task {
            for _ in 1...10 {
                Task {
                    await counter.increment() // Safely increments the counter
                }
            }
            
            try await Task.sleep(for: .milliseconds(100))

            print("Final counter value: \(await counter.getValue())") /// Safe read using `await`
        }
    }
}

actor Counter {
    private var value = 0
    
    func increment() {
        value += 1
    }
    
    func getValue() -> Int {
        return value
    }
}


