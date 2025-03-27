//
//  MainActorExamples.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 25/03/2025.
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
class HomeViewModel {
    var images: [PlatformImage] = []
}

struct AssumeIsolationDemonstrator {
    func methodA() {
        DispatchQueue.main.async {
            methodB()
        }
    }

    func methodB() {
        MainActor.assumeIsolated {
            someMainActorIsolatedMethod()
        }
    }
    
    /// This would be the alternative of using `assumeIsolated` with an extra suspension point as a result.
    func methodBAlternative() {
        /// Traditionally, you would use:
        assert(Thread.isMainThread)
        
        Task { @MainActor in
            someMainActorIsolatedMethod()
        }
    }

    @MainActor
    func someMainActorIsolatedMethod() {
        /// Some code that needs to execute on the main thread...
    }
    
    func assumeMainThreadModernConcurrency() {
        MainActor.assumeIsolated {
            /// Assume that the current method is executing on the main actor’s serial executor, or stop program execution.
        }
    }
    
}

struct ImageFetchingExamples {
    enum ImageFetchingError: Error {
        case imageDecodingFailed
    }
    
    /// Traditional example using `DispatchQueue.main`
    func fetchImage(for url: URL, completion: @escaping @Sendable (Result<PlatformImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, let image = PlatformImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(ImageFetchingError.imageDecodingFailed))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }

    /// Modern concurrency example using `@MainActor`.
    @MainActor
    func fetchImage(for url: URL) async throws -> PlatformImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = PlatformImage(data: data) else {
            throw ImageFetchingError.imageDecodingFailed
        }
        return image
    }
}
