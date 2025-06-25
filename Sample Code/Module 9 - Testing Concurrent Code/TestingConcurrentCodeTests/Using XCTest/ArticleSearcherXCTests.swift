//
//  ArticleSearcherXCTests.swift
//  TestingConcurrentCodeTests
//
//  Created by A.J. van der Lee on 25/06/2025.
//

import XCTest
@testable import TestingConcurrentCode

@MainActor
final class ArticleSearcherXCTests: XCTestCase {

    let articleSearcher = ArticleSearcher()
    
    override func setUp() async throws {
        // Call any asynchronous logic.
        
        await articleSearcher.prepareDatabase()
    }
    
    override func tearDown() async throws {
        // Call any asynchronous logic.
        
        await articleSearcher.closeDatabase()
    }
    
    func testEmptyQuery() async {
        await articleSearcher.search("")
        XCTAssertEqual(articleSearcher.searchResults, ArticleSearcher.articleTitlesDatabase, "Should return all articles")
    }

    func testWithSearchQuery() async {
        let expectation = self.expectation(description: "Search complete")

        /// Use observation tracking to track changes to the @Observable searchResults property.
        _ = withObservationTracking {
            articleSearcher.searchResults
        } onChange: {
            expectation.fulfill()
        }

        /// Perform the actual search for Article Three.
        articleSearcher.searchWithSearchTask("three")
        
        /// Asynchronously await for the expectation to fulfill.
        await fulfillment(of: [expectation], timeout: 10.0)
        
        /// Assert the result.
        XCTAssertEqual(articleSearcher.searchResults, ["Article three"], "Should return article three")
    }
}
