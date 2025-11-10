//
//  NotificationEmitter.swift
//  ConcurrencyMigrating
//
//  Created by A.J. van der Lee on 10/11/2025.
//

import Foundation

/// An emitter demonstrating how notifications are posted in both old- and new way.
struct NotificationEmitter {
    
    func emitOldWay() {
        NotificationCenter.default.post(name: .recentBuildsChanged, object: [RecentBuild(appName: "Stock Analyzer")])
    }
    
    func emitNewWay() {
        let recentBuilds = [RecentBuild(appName: "Stock Analyzer")]
        let message = RecentBuildsChangedMessage(recentBuilds: recentBuilds)
        NotificationCenter.default.post(message)
    }
    
}

/// For demonstration purposes: this is the old notification that was used in RocketSim.
extension Notification.Name {
    /// Posted when the recent builds for the current Simulator changed.
    /// - Contains the new recent builds array as an object.
    static let recentBuildsChanged = Notification.Name(rawValue: "recent.builds.changed")
}

/// A fake type for demonstration purposes.
struct RecentBuild {
    let appName: String
}

/// A custom `AsyncMessage` type that allows us to pass in the recent builds via a stored property.
struct RecentBuildsChangedMessage: NotificationCenter.AsyncMessage {
    typealias Subject = [RecentBuild]
    
    let recentBuilds: Subject
}

/// Using static member lookup, we allow to use autocompletion to find `recentBuildsChanged` more easily.
extension NotificationCenter.MessageIdentifier where Self == NotificationCenter.BaseMessageIdentifier<RecentBuildsChangedMessage> {

    static var recentBuildsChanged: NotificationCenter.BaseMessageIdentifier<RecentBuildsChangedMessage> {
        .init()
    }
}
