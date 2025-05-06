//
//  RetainCycleDemonstrator.swift
//  MemoryManagementConcurrency
//
//  Created by A.J. van der Lee on 06/05/2025.
//

#if os(iOS)
import UIKit
typealias Application = UIApplication
#elseif os(macOS)
import AppKit
typealias Application = NSApplication
#endif

import SwiftUI

@MainActor
struct RetainCycleDemonstrator {
    
    func demonstrateRetainCycle() {
        var loader: ImageLoader? = .init()
        loader?.startPollingWithRetainCycle()
        loader = nil
        print("Set loader to nil")
        
        /// Prints:
        /// Init!
        /// Set loader to nil
        /// Polling for new images...
        /// Polling for new images...
        /// Polling for new images...
        /// ...
        /// (DEINIT never printed because of retain cycle)
    }
    
    func demonstrateNoRetainCycle() {
        var loader: ImageLoader? = .init()
        loader?.startPollingWithoutRetainCycle()
        loader = nil
        print("Set loader to nil")

        /// Prints:
        /// Init!
        /// Deinit!
        /// Set loader to nil
    }
    
    func demonstrateAsyncSequenceRetainCycle() {
        var viewModel: AppLifecycleViewModel? = .init()
        viewModel?.startObservingDidBecomeActive()

        viewModel = nil
        print("Set viewModel to nil")
        
        /// Prints:
        /// Set viewModel to nil
        /// App became active
        /// App became active
        /// ...
    }
    
    func demonstrateAsyncSequenceNoRetainCycle() {
        var viewModel: AppLifecycleViewModel? = .init()
        viewModel?.startObservingDidBecomeActive()
        viewModel?.stopObservingDidBecomeActive()
        viewModel = nil
        print("Set viewModel to nil")

        /// Prints:
        /// Set viewModel to nil
        /// Deinit!
    }
}

@MainActor
final class ImageLoader {
    
    var task: Task<Void, Never>?
    
    init() {
        print("Init!")
    }
    
    deinit {
        print("Deinit!")
    }
    
    func startPollingWithRetainCycle() {
        task = Task {
            while true {
                self.pollNewImages()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
    
    func startPollingWithoutRetainCycle() {
        task = Task { [weak self] in
            while let self = self {
                self.pollNewImages()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
    
    private func pollNewImages() {
        print("Polling for new images...")
    }
}

@MainActor
@Observable
final class AppLifecycleViewModel {
    
    private(set) var isActive: Bool = false
    
    private var task: Task<Void, Never>?
    
    deinit {
        print("Deinit!")
    }
    
    /// Starting from Swift 6.2:
    /// isolated deinit {
    ///    print("Deinit!")
    ///    stopObservingDidBecomeActive()
    /// }
    
    func startObservingDidBecomeActive() {
        let center = NotificationCenter.default
        task = Task {
            for await _ in center.notifications(named: Application.didBecomeActiveNotification) {
                isActive = true
                print("App became active")
            }
        }
    }
    
    func stopObservingDidBecomeActive() {
        task?.cancel()
    }
}
