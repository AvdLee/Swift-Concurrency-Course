//
//  ContentView.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 21/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State var image: UIImage?

    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
            } else {
                Text("Loading...")
            }
        }.task {
            do {
                image = try await fetchImage()
                print("Image loading completed")
            } catch {
                print("Image loading failed: \(error)")
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
        let fallbackImage = UIImage(named: "fallback_image")!
        
        let imageURL = URL(string: "https://httpbin.org/image")!
        var imageRequest = URLRequest(url: imageURL)
        imageRequest.allHTTPHeaderFields = ["accept": "image/jpeg"]

        /// Check for cancellation before the network request starts.
        guard !Task.isCancelled else {
            return fallbackImage
        }
        
        print("Starting network request...")
        let (imageData, _) = try await URLSession.shared.data(for: imageRequest)

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
            let (imageData, _) = try await URLSession.shared.data(for: imageRequest)

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
