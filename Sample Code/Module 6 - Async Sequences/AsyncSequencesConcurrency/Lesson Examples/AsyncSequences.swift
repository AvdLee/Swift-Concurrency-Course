//
//  AsyncSequences.swift
//  AsyncSequencesConcurrency
//
//  Created by A.J. van der Lee on 10/04/2025.
//

struct Counter: AsyncSequence, AsyncIteratorProtocol {

    let limit: Int
    var current = 1

    mutating func next() async -> Int? {
        guard !Task.isCancelled else {
            /// Return `nil` so the iteration stops as we're cancelled.
            return nil
        }

        guard current <= limit else {
            /// Return `nil` and stop the iteration as we reached the limit.
            return nil
        }

        let result = current
        current += 1
        return result
    }

    func makeAsyncIterator() -> Counter {
        self
    }
}

struct AsyncSequenceDemonstrator {
    func demonstrate() async {
        for await count in Counter(limit: 5) {
            print(count)
        }
        print("Counter finished")
        
        // Prints:
        // 1
        // 2
        // 3
        // 4
        // 5
        // Counter finished
        
        for await count in Counter(limit: 5).filter({ $0 % 2 == 0 }) {
            print(count)
        }
        print("Counter finished")

        // Prints:
        // 2
        // 4
        // Counter finished
        
        let counterSequence = Counter(limit: 5)
            .map { $0 % 2 == 0 ? "Even" : "Odd" }
        for await count in counterSequence {
            print(count)
        }
        print("Counter finished")

        // Prints:
        // Odd
        // Even
        // Odd
        // Even
        // Odd
        // Counter finished
        
        let contains = await Counter(limit: 5).contains(3)
        print(contains) // Prints: true
    }
}
