//
//  ArticleSearcher.swift
//  TestingConcurrentCode
//
//  Created by A.J. van der Lee on 25/06/2025.
//

import SwiftUI

/// The original `ArticleSearcher` which is marked to run on the `@MainActor`.
@MainActor
@Observable
final class ArticleSearcher {
    
    static let articleTitlesDatabase = [
        "Article one",
        "Article two",
        "Article three",
    ]
    
    var searchResults: [String] = ArticleSearcher.articleTitlesDatabase
    
    private var currentSearchTask: Task<Void, Never>?
    private var isSearching = false
    
    /// Using manual cancellation management.
    func searchWithSearchTask(_ query: String) {
        /// Cancel any previous searches that might be 'sleeping'.
        currentSearchTask?.cancel()
        
        currentSearchTask = Task {
            do {
                isSearching = true
                
                /// Sleep for 0.5 seconds to wait for a pause in typing before executing the search.
                try await Task.sleep(for: .milliseconds(500))
                
                print("Starting to search!")
                
                /// A simplified static result and search implementation.
                searchResults = Self.articleTitlesDatabase
                    .filter { $0.lowercased().contains(query.lowercased()) }
                isSearching = false
            } catch {
                print("Search was cancelled!")
            }
        }
    }
    
    /// Async alternative to allow searching using the `task` modifier in SwiftUI.
    func search(_ query: String) async {
        do {
            guard !query.isEmpty else {
                searchResults = Self.articleTitlesDatabase
                return
            }
            
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
}

/// Dummy methods for our testing examples.
/// This allows us to demonstrate how to use setUp and tearDown methods in both XCTest and Swift Testing.
extension ArticleSearcher {
    
    func prepareDatabase() async {
        /// Imagine preparing the database here.
    }
    
    func closeDatabase() async {
        /// Imagine closing the database here.
    }
}
