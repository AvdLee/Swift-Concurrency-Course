//
//  ImageFetcherXCTests.swift
//  TestingConcurrentCode
//
//  Created by A.J. van der Lee on 25/06/2025.
//

import XCTest
@testable import TestingConcurrentCode
import ConcurrencyExtras

@MainActor
final class ImageFetcherXCTests: XCTestCase {
    
    /// This test is flaky since we're validating the state of `isLoading` right after the `Task` starts executing.
    /// The task finishes before we have a chance to test the loading value.
    func testIsLoadingFlaky() async throws {
        let imageFetcher = ImageFetcher(downloadImage: { url in
            /// Return plain `Data()` for this test as we're just interested in the `isLoading` state.
            return Data()
        })
        
        /// Call into the `fetchImage` method to ensure the `isLoading` state flips to `true` and `false`.
        let task = Task { _ = try await imageFetcher.fetchImage(imageURL: URL(string: "https://example-image.url")!) }
        XCTAssertEqual(imageFetcher.isLoading, true)
        
        /// Await the result of the image fetching.
        try await task.value
        
        /// Validate that `isLoading` restores to `false`.
        XCTAssertEqual(imageFetcher.isLoading, false)
    }
    
    /// By running the test using a main serial executor, we allow ourselves to use `Task.yield()` and read state in between.
    func testIsLoadingWithMainSerialExecutor() async throws {
        try await withMainSerialExecutor {
            let imageFetcher = ImageFetcher(downloadImage: { url in
                
                /// Yield here to allow the test to continue evaluation. This allows us to check the `isLoading` state.
                await Task.yield()
                
                /// Return plain `Data()` for this test as we're just interested in the `isLoading` state.
                return Data()
            })
            
            /// Call into the `fetchImage` method to ensure the `isLoading` state flips to `true` and `false`.
            let task = Task { _ = try await imageFetcher.fetchImage(imageURL: URL(string: "https://example-image.url")!) }
            
            /// Suspends the current test task and allow the above task to start executing up until `downloadImage(...)` is called.
            await Task.yield()
            
            /// Check the `isLoading` state while we're 'paused' just at `downloadImage`.
            XCTAssertEqual(imageFetcher.isLoading, true)
            
            /// Await the result of the image fetching.
            try await task.value
            
            /// Validate that `isLoading` restores to `false`.
            XCTAssertEqual(imageFetcher.isLoading, false)
        }
    }
}
