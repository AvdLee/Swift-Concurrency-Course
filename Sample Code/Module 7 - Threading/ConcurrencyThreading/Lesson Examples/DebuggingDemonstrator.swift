//
//  DebuggingDemonstrator.swift
//  ConcurrencyThreading
//
//  Accompanies the lesson "Debugging Swift Concurrency code".
//

import Foundation
import LegacyArticles

@MainActor
final class ArticlesViewModel {
    var articles: [String] = []

    /// Crashes in Swift 6 language mode.
    ///
    /// The closure is isolated to the main actor, but the legacy API calls it
    /// from a background queue. Swift verifies this at runtime and stops the app
    /// in `_dispatch_assert_queue_fail`.
    func loadCrashing() {
        LegacyArticleSync().sync { articles in
            self.articles = articles
        }
    }

    /// Stops at the exact line where the assumption breaks.
    ///
    /// Marking the closure as `@Sendable` makes it nonisolated, so Swift no longer
    /// verifies the isolation for us. We verify it ourselves with an assertion.
    func loadWithAssertion() {
        LegacyArticleSync().sync { @Sendable articles in
            MainActor.assertIsolated("Expected the callback on the main actor")
            print("Received \(articles)")
        }
    }

    /// Makes the boundary explicit by hopping to the main actor ourselves.
    func loadFixed() {
        LegacyArticleSync().sync { @Sendable articles in
            Task { @MainActor in
                self.articles = articles
                print("Updated articles on the main actor: \(self.articles)")
            }
        }
    }
}

/// Prints the isolation of the code calling this function.
func logIsolation(isolation: isolated (any Actor)? = #isolation) {
    print("Running with isolation: \(String(describing: isolation))")
}

@MainActor
struct DebuggingDemonstrator {
    let viewModel = ArticlesViewModel()

    /// Prints `Optional(Swift.MainActor)` for main actor code and `nil` for non-isolated code.
    func demonstrateIsolationLogging() async {
        logIsolation()
        // Prints: Running with isolation: Optional(Swift.MainActor)

        await fetchArticles()
        // Prints: Running with isolation: nil
    }

    /// `@concurrent` makes sure this method runs non-isolated.
    /// Without it, this project's `NonisolatedNonsendingByDefault` setting
    /// would make the method inherit the isolation of its caller.
    @concurrent
    private func fetchArticles() async {
        logIsolation()
    }

    /// Names show up in Instruments and are readable using `Task.name`.
    func demonstrateTaskNaming() {
        guard #available(iOS 26, visionOS 26, *) else {
            print("Task names require iOS 26 or visionOS 26.")
            return
        }

        let task = Task(name: "Refresh articles") {
            print("Running task: \(Task.name ?? "Unnamed task")")
            // Prints: Running task: Refresh articles
        }
        _ = task
    }
}
