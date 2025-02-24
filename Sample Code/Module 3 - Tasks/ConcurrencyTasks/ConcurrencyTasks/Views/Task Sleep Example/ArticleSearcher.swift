//
//  ArticleSearcher.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import SwiftUI

@MainActor
@Observable
final class ArticleSearcher {

    private static let articleTitlesDatabase = [
        "Article one",
        "Article two",
        "Article three",
    ]

    var searchResults: [String] = ArticleSearcher.articleTitlesDatabase

    private var currentSearchTask: Task<Void, Never>?

    func search(_ query: String) {
        /// Cancel any previous searches that might be 'sleeping'.
        currentSearchTask?.cancel()

        let newSearchTask = Task {
            do {
                /// Sleep for 0.5 seconds to wait for a pause in typing before executing the search.
                try await Task.sleep(for: .milliseconds(500))

                print("Starting to search!")

                /// A simplified static result and search implementation.
                searchResults = Self.articleTitlesDatabase
                    .filter { $0.lowercased().contains(query.lowercased()) }
            } catch {
                print("Search was cancelled!")
            }
        }
        self.currentSearchTask = newSearchTask
    }
}
