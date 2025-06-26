//
//  ArticleSearcherSwiftTesting.swift
//  TestingConcurrentCodeTests
//
//  Created by A.J. van der Lee on 25/06/2025.
//

import Testing
@testable import TestingConcurrentCode
import Observation

@Suite(ArticleSearcherDatabaseTrait())
@MainActor
final class ArticleSearcherSwiftTesting {

    @MainActor
    struct Environment {
        @TaskLocal static var articleSearcher = ArticleSearcher()
    }
    
    @Test(ArticleSearcherDatabaseTrait())
    func testEmptyQuery() async {
        await Environment.articleSearcher.search("")
        #expect(Environment.articleSearcher.searchResults == ArticleSearcher.articleTitlesDatabase)
    }

    @Test(ArticleSearcherDatabaseTrait())
    func testWithSearchQuerySearchTask() async {
        await withCheckedContinuation { continuation in
            _ = withObservationTracking {
                Environment.articleSearcher.searchResults
            } onChange: {
                continuation.resume()
            }
            
            Environment.articleSearcher.searchWithSearchTask("three")
        }
        
        #expect(Environment.articleSearcher.searchResults == ["Article three"])
    }
    
    @Test
    func testWithSearchQuery() async {
        let articleSearcher = ArticleSearcher()
        await articleSearcher.search("three")
        #expect(articleSearcher.searchResults == ["Article three"])
    }
    
    @Test
    func testWithSearchQueryAndObservation() async {
        let articleSearcher = ArticleSearcher()
        
        /// Create and await for the confirmation.
        await confirmation { confirmation in
            /// Start observation tracking.
            _ = withObservationTracking {
                articleSearcher.searchResults
            } onChange: {
                /// Call the confirmation when search results changes.
                confirmation()
            }
            
            /// Start and await searching.
            /// Note: using `await` here is crucial to make confirmation work.
            /// the confirmation method would otherwise return directly.
            await articleSearcher.search("three")
        }
        
        #expect(articleSearcher.searchResults == ["Article three"])
    }

}

struct ArticleSearcherDatabaseTrait: SuiteTrait, TestTrait, TestScoping {
        
    @MainActor
    func provideScope(for test: Test, testCase: Test.Case?, performing function: () async throws -> Void) async throws {
        print("Running for test \(test.name)")

        let articleSearcher = ArticleSearcher()
        try await ArticleSearcherSwiftTesting.Environment.$articleSearcher.withValue(articleSearcher) {
            await articleSearcher.prepareDatabase()
            try await function()
            await articleSearcher.closeDatabase()
        }
    }
}
