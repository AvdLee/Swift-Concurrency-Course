//
//  GlobalVariables.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 25/03/2025.
//

import Foundation

class ImageCache {
    /// When you've enabled Swift 6 language mode:
    /// Error: Static property 'shared' is not concurrency-safe because it is nonisolated global shared mutable state
    // static var shared = ImageCache()
}

struct APIProvider: Sendable {
    /// We've now indicated to the compiler we're taking responsibility ourselves
    /// regarding thread-safety access of this global variable.
    nonisolated(unsafe) static private(set) var shared: APIProvider!

    let apiURL: URL

    init(apiURL: URL) {
        self.apiURL = apiURL
    }

    static func configure(apiURL: URL) {
        /// We know this is the only mutation point for `shared`.
        shared = APIProvider(apiURL: apiURL)
    }
}
