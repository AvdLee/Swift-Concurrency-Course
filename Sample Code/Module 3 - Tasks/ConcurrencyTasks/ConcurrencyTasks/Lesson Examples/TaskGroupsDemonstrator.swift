//
//  TaskGroupsDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import UIKit
import Foundation

struct TaskGroupsDemonstrator {
    /// This example fetches images without failing the task group if a photo download fails.
    func fetchImages() async throws -> [UIImage] {
        try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self) { taskGroup in
            let photoURLs = try await listPhotoURLs(inGallery: "Amsterdam Holiday")
            
            for photoURL in photoURLs {
                taskGroup.addTask { try await downloadPhoto(url: photoURL) }
            }
            
            return try await taskGroup.reduce(into: [UIImage]()) { partialResult, name in
                partialResult.append(name)
            }
        }
    }
    
    /// This example forwards any errors in child tasks to ensure the Task group fails
    /// whenever an image download fails.
    func fetchImagesWithFailure() async throws -> [UIImage] {
        try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self) { taskGroup in
            let photoURLs = try await listPhotoURLs(inGallery: "Amsterdam Holiday")
            
            for photoURL in photoURLs {
                let didAddTask = taskGroup.addTaskUnlessCancelled {
                    try await downloadPhoto(url: photoURL)
                }
                print("Added task: \(didAddTask)")
            }
            
            var images = [UIImage]()

            /// Note the use of `next()` to propegate failures to the task group:
            while let downloadImage = try await taskGroup.next() {
                images.append(downloadImage)
            }

            return images
        }
    }
    
    private func listPhotoURLs(inGallery gallery: String) async throws -> [URL] {
        /// For the sake of this demo code, we'll return a static list of URLs after a short sleep.
        try await Task.sleep(for: .milliseconds(500))
        
        return [
            URL(string: "https://httpbin.org/image/jpeg")!,
            URL(string: "https://httpbin.org/image/png")!
        ]
    }
    
    private func downloadPhoto(url: URL) async throws -> UIImage {
        let (imageData, _) = try await URLSession.shared.data(from: url)
        let fallbackImage = UIImage(named: "fallback_image")!

        guard let image = UIImage(data: imageData) else {
            /// Converting the data to `UIImage` failed, return our fallback image.
            return fallbackImage
        }

        return image
    }
}
