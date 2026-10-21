//
//  LegacyArticleSync.swift
//  LegacyArticles
//
//  Accompanies the lesson "Debugging Swift Concurrency code".
//

import Foundation

/// Simulates an older API from a module written in Swift 5 or Objective-C,
/// without isolation annotations. It calls its completion handler on a background queue.
public final class LegacyArticleSync {
    public init() {}

    public func sync(completion: @escaping ([String]) -> Void) {
        DispatchQueue.global().async {
            completion(["Article"])
        }
    }
}
