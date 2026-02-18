//
//  LimitingConcurrentTasksDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 18/02/2026.
//

import Foundation

struct LimitingConcurrentTasksDemonstrator {

    /// Demonstrates the sliding window pattern for fire-and-forget tasks.
    func demonstrateLimitedConcurrency() async {
        let items = Array(1...10)
        let maxConcurrency = 3
        print("Starting \(items.count) tasks with max concurrency of \(maxConcurrency)")

        await withTaskGroup(of: Void.self) { group in
            var pending = items[...]

            for _ in 0..<maxConcurrency {
                guard let item = pending.popFirst() else { break }
                group.addTask {
                    await processItem(item)
                }
            }

            while let item = pending.popFirst(), let _ = await group.next() {
                group.addTask {
                    await processItem(item)
                }
            }
        }

        print("All tasks completed")
    }

    /// Demonstrates the sliding window pattern while collecting results.
    func demonstrateLimitedConcurrencyWithResults() async {
        let items = Array(1...10)
        let maxConcurrency = 3
        print("Starting \(items.count) tasks (with results) with max concurrency of \(maxConcurrency)")

        let results: [String] = await withTaskGroup(of: String.self) { group in
            var pending = items[...]
            var collected: [String] = []

            for _ in 0..<maxConcurrency {
                guard let item = pending.popFirst() else { break }
                group.addTask {
                    await transformItem(item)
                }
            }

            while let result = await group.next() {
                collected.append(result)
                if let item = pending.popFirst() {
                    group.addTask {
                        await transformItem(item)
                    }
                }
            }

            return collected
        }

        print("Collected \(results.count) results: \(results)")
    }

    private func processItem(_ item: Int) async {
        let duration = Double.random(in: 0.1...0.5)
        try? await Task.sleep(for: .seconds(duration))
        print("Processed item \(item) (took \(String(format: "%.2f", duration))s)")
    }

    private func transformItem(_ item: Int) async -> String {
        let duration = Double.random(in: 0.1...0.5)
        try? await Task.sleep(for: .seconds(duration))
        let result = "Result-\(item)"
        print("Transformed item \(item) → \(result) (took \(String(format: "%.2f", duration))s)")
        return result
    }
}
