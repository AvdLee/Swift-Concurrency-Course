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
    
    func fetchImage(urlRequest: URLRequest, completion: @escaping @Sendable (Result<PlatformImage, Swift.Error>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { imageData, _, error in
            do {
                if let error {
                    throw error
                }
                
                guard let imageData, let image = PlatformImage(data: imageData) else {
                    throw Error.imageConversionFailed
                }
                
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }
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
