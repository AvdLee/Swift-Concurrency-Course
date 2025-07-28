//
//  ImageFetcher.swift
//  TestingConcurrentCode
//
//  Created by A.J. van der Lee on 25/06/2025.
//

import Foundation

#if os(macOS)
import AppKit
typealias PlatformImage = NSImage
#else
import UIKit
typealias PlatformImage = UIImage
#endif

@MainActor
@Observable
final class ImageFetcher {
    
    var isLoading = false
    
    // Allow for injecting the download logic explictly for testing purposes.
    let downloadImage: (URL) async throws -> Data
    
    init(downloadImage: @escaping (URL) async throws -> Data) {
        self.downloadImage = downloadImage
    }
    
    func fetchImage(imageURL: URL) async throws -> PlatformImage {
        isLoading = true
        defer { isLoading = false }
        
        let fallbackImage = PlatformImage(named: "fallback_image")!
        
        let imageData = try await downloadImage(imageURL)
        
        /// Check for cancellation after the network request.
        /// Potentially, you would perform image operations on `imageData`
        guard !Task.isCancelled else {
            return fallbackImage
        }

        /// ... Perform heavy image operations on `imageData` since the task is not cancelled.

        guard let image = PlatformImage(data: imageData) else {
            /// Converting the data to `UIImage` failed, return our fallback image.
            return fallbackImage
        }

        /// We completed the image download and heavy operations without cancellations, return the image.
        return image
    }
}
