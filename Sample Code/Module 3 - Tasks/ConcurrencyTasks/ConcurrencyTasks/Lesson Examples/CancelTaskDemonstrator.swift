//
//  CancelTaskDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import UIKit
import Foundation

struct CancelTaskDemonstrator {

    /// Use this method to try out the cancellation logic from the Task cancellation lesson.
    /// See the `imageTask.cancel()` line at the tail of this method.
    func fetchImageCancelDemonstration() async throws -> UIImage {
        let imageTask = Task {
            let fallbackImage = UIImage(systemName: "fallback_image")!

            let imageURL = URL(string: "https://httpbin.org/image")!
            var imageRequest = URLRequest(url: imageURL)
            imageRequest.allHTTPHeaderFields = ["accept": "image/jpeg"]

            /// Check for cancellation before the network request starts.
            guard !Task.isCancelled else {
                return fallbackImage
            }

            print("Starting network request...")

            let imageData: Data
            do {
                let (data, _) = try await URLSession.shared.data(for: imageRequest)
                imageData = data
            } catch is CancellationError {
                /// URLSession throws a CancellationError if the task is cancelled while awaiting.
                /// Return the fallback image instead of propagating the error.
                return fallbackImage
            }

            /// Check for cancellation after the network request.
            /// Potentially, you would perform image operations on `imageData`
            guard !Task.isCancelled else {
                return fallbackImage
            }

            /// ... Perform heavy image operations on `imageData` since the task is not cancelled.

            guard let image = UIImage(data: imageData) else {
                /// Converting the data to `UIImage` failed, return our fallback image.
                return fallbackImage
            }

            /// We completed the image download and heavy operations without cancellations, return the image.
            return image
        }
        
        /// To try out the cancellation logic, you can uncomment the following line
        /// so the task will cancel right away:
        // imageTask.cancel()
        return try await imageTask.value
    }
}

extension CancelTaskDemonstrator {
    /// Demonstrates how a parent task cancels inner tasks upon cancellation.
    func parentTaskCancellationExample() async {
        let handle = Task {
            print("Parent task started")

            async let childTask1 = someWork(id: 1)
            async let childTask2 = someWork(id: 2)
            let finishedTaskIDs = try await [childTask1, childTask2]
            print(finishedTaskIDs)
        }

        /// Cancel parent task after a short delay.
        try? await Task.sleep(for: .milliseconds(200))
        
        /// This cancels both childTask1 and childTask2:
        handle.cancel()

        /// Wait for the parent task and notice how cancellation propagates.
        try? await handle.value
        print("Parent task finished")
    }

    func someWork(id: Int) async throws -> Int {
        for i in 1...5 {
            /// Check for cancellation and throw an error if detected.
            try Task.checkCancellation()
            print("Child task \(id): Step \(i)")
            
            /// Add a delay so we're being cancelled before running into the next loop.
            try await Task.sleep(for: .milliseconds(400))
        }
        
        return id
    }
}
