//
//  MigratingClosures.swift
//  ConcurrencyMigrating
//
//  Created by A.J. van der Lee on 01/07/2025.
//

import Foundation
#if os(macOS)
import AppKit
typealias PlatformImage = NSImage
#else
import UIKit
typealias PlatformImage = UIImage
#endif

struct ImageFetcher {
    enum Error: Swift.Error {
        case imageConversionFailed
    }
    
    /// Right-click this method to use Xcode's refactoring options.
    func fetchImage(urlRequest: URLRequest, completion: @escaping @Sendable (Result<PlatformImage, Swift.Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { imageData, _, error in
            do {
                if let error = error {
                    throw error
                }
                
                guard let imageData = imageData, let image = PlatformImage(data: imageData) else {
                    throw Error.imageConversionFailed
                }
                
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct MigrationDemonstrator {
    func demonstrate() {
        let imageURL = URL(string: "https://httpbin.org/image")!
        var imageRequest = URLRequest(url: imageURL)
        imageRequest.allHTTPHeaderFields = ["accept": "image/jpeg"]
        
        let imageFetcher = ImageFetcher()
        imageFetcher.fetchImage(urlRequest: imageRequest) { result in
            print(result)
        }
        
    }
}

/// This instance shows what a migrated version of the `ImageFetcher` could look like.
/// Unfortunately, Xcode's refactoring options don't end up with the method you'll see inside this instance.
/// Therefore, manual migration is often required.
struct ImageFetcherMigrated {
    enum Error: Swift.Error {
        case imageConversionFailed
    }
    
    func fetchImage(urlRequest: URLRequest) async throws -> PlatformImage {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        guard let image = PlatformImage(data: data) else {
            throw Error.imageConversionFailed
        }
        return image
    }
}
