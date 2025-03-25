//
//  MutableUser.swift
//  SendableConcurrency
//
//  Created by A.J. van der Lee on 19/03/2025.
//

import Foundation

private final class ArticleTitlesCache: @unchecked Sendable {
    private let cacheMutatingLock = DispatchQueue(label: "cache.lock.queue")
    
    /// A private mutable member which is only accessed inside this cache via the serial lock queue.
    private var articleTitles: Set<String> = []
    
    /// Returns the total number of cached article titles.
    var count: Int {
        articleTitles.count
    }
    
    /// ...
    
    func addArticleTitle(_ title: String) {
        cacheMutatingLock.sync {
            _ = articleTitles.insert(title)
        }
    }
    
    func cachedArticleTitles() -> Set<String> {
        return cacheMutatingLock.sync {
            return articleTitles
        }
    }
}

/// This would be a proper way to migrate the above `ArticleTitlesCache` into Swift Concurrency
/// by making use of an `actor`.
private actor ArticleTitlesCacheActor {
    private var articleTitles: Set<String> = []

    /// Returns the total number of cached article titles.
    var count: Int {
        articleTitles.count
    }

    /// Adds a new article title to the cache.
    func addArticleTitle(_ title: String) {
        articleTitles.insert(title)
    }

    /// Returns the cached article titles.
    func cachedArticleTitles() -> Set<String> {
        return articleTitles
    }
}
