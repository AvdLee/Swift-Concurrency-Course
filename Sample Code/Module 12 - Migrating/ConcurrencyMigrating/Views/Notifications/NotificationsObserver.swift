//
//  NotificationsObserver.swift
//  ConcurrencyMigrating
//
//  Created by A.J. van der Lee on 10/11/2025.
//

import UIKit
import Foundation

/// Observes both custom and standard notifications.
final class NotificationsObserver {
    
    /// The tokens that relate to some of the new API observations used.
    var token: NotificationCenter.ObservationToken?
    var recentBuildsToken: NotificationCenter.ObservationToken?
    
    /// A combined entry method for observing.
    func startObserving() {
        startObservingOldWay()
        startObservingNewWay()
    }
    
    /// Demonstrates observing notifications using the new 26+ APIs.
    func startObservingNewWay() {
        token = NotificationCenter.default.addObserver(
            of: UIApplication.self,
            for: .didBecomeActive) { [weak self] message in
            self?.handleDidBecomeActive()
        }
        
        recentBuildsToken = NotificationCenter.default.addObserver(of: [RecentBuild].self, for: .recentBuildsChanged) { [weak self] message in
            self?.handleNewRecentBuilds(message.recentBuilds)
        }
    }
    
    /// Demonstrates the old way of observing notifications.
    func startObservingOldWay() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                self?.handleDidBecomeActive()
        })
        
        NotificationCenter.default.addObserver(forName: .recentBuildsChanged, object: nil, queue: nil) { [weak self] notification in
            guard let recentBuilds = notification.object as? [RecentBuild] else { return }
            self?.handleNewRecentBuilds(recentBuilds)
        }
    }

    /// Purposely attributed with `@MainActor` to show how both old and new notification APIs deal with isolation domains.
    @MainActor
    func handleDidBecomeActive() {
        print("Did become active!")
    }
    
    nonisolated func handleNewRecentBuilds(_ recentBuilds: [RecentBuild]) {
        print("Recent builds is now: \(recentBuilds)")
    }
}
