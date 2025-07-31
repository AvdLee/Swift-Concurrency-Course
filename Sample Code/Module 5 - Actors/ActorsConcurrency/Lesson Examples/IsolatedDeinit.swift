//
//  IsolatedDeinit.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 31/07/2025.
//

import Foundation

actor FileDownloader {
    var currentDownloadTask: Task<Void, Error>?
    
    func start() {
        /// A fake download task with a sleep, just to demonstrate this behavior.
        currentDownloadTask = Task.detached {
            try await Task.sleep(for: .seconds(2))
            print("Download task completed")
        }
    }

    func cancel() {
        currentDownloadTask?.cancel()
        print("Download task cancelled")
    }

    isolated deinit {
        cancel()
    }
}

struct IsolatedDeinitDemonstrator {
    func demonstrate() {
        Task {
            var downloader: FileDownloader? = FileDownloader()
            await downloader?.start()
            
            try? await Task.sleep(for: .seconds(1))
            downloader = nil // Triggers deinit
        }
    }
}
