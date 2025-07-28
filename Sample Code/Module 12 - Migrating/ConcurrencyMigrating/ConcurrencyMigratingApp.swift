//
//  ConcurrencyMigratingApp.swift
//  ConcurrencyMigrating
//
//  Created by A.J. van der Lee on 01/07/2025.
//

import SwiftUI

@main
struct ConcurrencyMigratingApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Search with Combine", systemImage: "magnifyingglass") {
                    Concurrency_SearchArticleView()
                }
                Tab("Search with Concurrency", systemImage: "sparkle.magnifyingglass") {
                    Concurrency_SearchArticleView()
                }
            }
        }
    }
}
