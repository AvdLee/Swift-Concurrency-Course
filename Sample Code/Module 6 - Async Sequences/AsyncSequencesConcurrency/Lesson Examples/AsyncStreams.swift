//
//  AsyncStreams.swift
//  AsyncSequencesConcurrency
//
//  Created by A.J. van der Lee on 10/04/2025.
//

import Foundation
import Combine

struct AsyncStreamDemonstrator {
    enum DemonstrationError: Error {
        case streamFinishedWithoutData
    }

    let imageURL = URL(string: "https://httpbin.org/image")!

    func demonstrateSingleConsumer() {
        let indexStream = AsyncStream { continuation in
            (0...5).forEach { index in
                continuation.yield(index)
            }

            continuation.finish()
        }

        Task {
            print("Index monitor 1 started...")
            
            for await index in indexStream {
                print("Monitor 1: \(index)")
            }
        }

        Task {
            print("Index monitor 2 started...")
            
            for await index in indexStream {
                print("Monitor 2: \(index)")
            }
        }
    }
    
    func demonstrateTermination() async {
        let indexStream = AsyncStream<Int> { continuation in
            continuation.onTermination = { _ in
                print("Index stream terminated.")
            }
            
            /// Terminate right away to demonstrate no more values will be emitted.
            continuation.finish()
            
            (0...5).forEach { index in
                continuation.yield(index)
            }
        }

        /// Wait to ensure the index stream gets terminated before monitoring.
        try? await Task.sleep(for: .seconds(1))

        print("Index monitor 1 started...")

        for await index in indexStream {
            print("Monitor 1: \(index)")
        }
        
        print("Index monitor finished")
    }
    
    func demonstrateBufferPolicy() async {
        print("# Buffer 1: unbounded")
        let unboundedStream = AsyncStream(bufferingPolicy: .unbounded) { continuation in
            (0...5).forEach { index in
                print("Yielding index \(index)...")
                continuation.yield(index)
            }
            
            continuation.finish()
        }

        /// Wait to ensure all index values are emitted.
        try? await Task.sleep(for: .seconds(1))

        print("Start awaiting indexes...")

        /// Iterate over the stream of values.
        for await index in unboundedStream {
            print("Received index: \(index)")
        }

        /* Prints out:
         Yielding index 0...
         Yielding index 1...
         Yielding index 2...
         Yielding index 3...
         Yielding index 4...
         Yielding index 5...
         Start awaiting indexes...
         Received index: 0
         Received index: 1
         Received index: 2
         Received index: 3
         Received index: 4
         Received index: 5
         */
        
        print("# Buffer 2: Buffering newest (1)")
        let bufferingNewestStream = AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            (0...5).forEach { index in
                print("Yielding index \(index)...")
                continuation.yield(index)
            }
            
            continuation.finish()
        }

        /// Wait to ensure all index values are emitted.
        try? await Task.sleep(for: .seconds(1))

        print("Start awaiting indexes...")

        /// Iterate over the stream of values.
        for await index in bufferingNewestStream {
            print("Received index: \(index)")
        }

        /* Prints out:
         Yielding index 0...
         Yielding index 1...
         Yielding index 2...
         Yielding index 3...
         Yielding index 4...
         Yielding index 5...
         Start awaiting indexes...
         Received index: 5
         */
        
        print("# Buffer 3: Buffering oldest (1)")
        let bufferingOldestStream = AsyncStream(bufferingPolicy: .bufferingOldest(1)) { continuation in
            (0...5).forEach { index in
                print("Yielding index \(index)...")
                continuation.yield(index)
            }
            
            continuation.finish()
        }

        /// Wait to ensure all index values are emitted.
        try? await Task.sleep(for: .seconds(1))

        print("Start awaiting indexes...")

        /// Iterate over the stream of values.
        for await index in bufferingOldestStream {
            print("Received index: \(index)")
        }

        /* Prints out:
         Yielding index 0...
         Yielding index 1...
         Yielding index 2...
         Yielding index 3...
         Yielding index 4...
         Yielding index 5...
         Start awaiting indexes...
         Received index: 0
         */
        
        print("# Buffer 4: Buffering newest (0)")
        let bufferingNewerOnlyStream = AsyncStream(bufferingPolicy: .bufferingNewest(0)) { continuation in
            print("Yielding index 1...")
            continuation.yield(1)
            
            Task {
                try? await Task.sleep(for: .seconds(2))
                print("Yielding index 2...")
                continuation.yield(2)
                continuation.finish()
            }
        }

        /// Wait to ensure all index values are emitted.
        try? await Task.sleep(for: .seconds(1))

        print("Start awaiting indexes...")

        /// Iterate over the stream of values.
        for await index in bufferingNewerOnlyStream {
            print("Received index: \(index)")
        }

        /* Prints out:
         Yielding index 1...
         Start awaiting indexes...
         Yielding index 2...
         Received index: 2
         */
    }
    
    func demonstrateFileDownloading() async throws -> Data {
        do {
            let fileDownloader = FileDownloader()
            
            for try await status in fileDownloader.download(imageURL) {
                switch status {
                case .downloading(let progress):
                    print("Downloading progress: \(progress)")
                case .finished(let data):
                    print("Downloading completed with data: \(data)")
                    return data
                }
            }
            print("Download finished and stream closed without data")
            throw DemonstrationError.streamFinishedWithoutData
        } catch {
            print("Download failed with \(error)")
            throw error
        }
    }
    
    func demonstrateCancellation() {
        let task = Task.detached {
            do {
                let fileDownloader = FileDownloader()
                
                for try await status in fileDownloader.download(imageURL) {
                    switch status {
                    case .downloading(let progress):
                        print("Downloading progress: \(progress)")
                    case .finished(let data):
                        print("Downloading completed with data: \(data)")
                    }
                }
            } catch {
                print("Download failed with \(error)")
            }
        }
        task.cancel()
    }
}

struct FileDownloader {
    enum Status {
        case downloading(Float)
        case finished(Data)
    }
    
    enum FileDownloadingError: Error {
        case missingData
    }

    func download(_ url: URL, progressHandler: @Sendable @escaping (Float) -> Void, completion: @Sendable @escaping (Result<Data, Error>) -> Void) throws {
        /// Proper progress reporting should be done via `URLSessionDelegate`. For the sake of this example,
        /// we're only reporting progress on start and finish.
        progressHandler(0.1)
        
        /// Focussing on images only for this example.
        var imageRequest = URLRequest(url: url)
        imageRequest.allHTTPHeaderFields = ["accept": "image/jpeg"]
        
        print("Starting file download...")

        let task = URLSession.shared.dataTask(with: imageRequest) { data, response, error in
            progressHandler(1.0)
            
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data {
                completion(.success(data))
            } else {
                completion(.failure(FileDownloadingError.missingData))
            }
        }
        task.resume()
    }
}

extension FileDownloader {
    /// Define a download overload which provides an `AsyncThrowingStream`.
    func download(_ url: URL) -> AsyncThrowingStream<Status, Error> {
        return AsyncThrowingStream { continuation in
            /// Configure a termination callback to understand the lifetime of your stream.
            continuation.onTermination = { @Sendable terminationReason in
                print("Stream termination reason: \(terminationReason)")
            }
            
            do {
                /// Call into the original closure-based method.
                try self.download(url, progressHandler: { progress in
                    /// Send progress updates through the stream.
                    continuation.yield(.downloading(progress))
                }, completion: { result in
                    let useShorthandYielding: Bool = false
                    
                    if useShorthandYielding {
                        /// Option 1: Shorthand yielding
                        ///  In the .success(_:) case, this returns the associated value from the iterator’s next() method.
                        ///  If the result is the failure(_:) case, this call terminates the stream with the result’s error, by calling finish(throwing:).
                        continuation.yield(with: result.map { .finished($0) })
                        continuation.finish()
                    } else {
                        /// Option 2: Yielding using a switch case.
                        switch result {
                        case .success(let data):
                            /// Send a finished message to the stream.
                            continuation.yield(.finished(data))
                            
                            /// Terminate the continuation.
                            continuation.finish()
                        case .failure(let error):
                            
                            /// Finished and terminate the continuation with the error:
                            continuation.finish(throwing: error)
                        }
                    }
                })
            } catch {
                /// Finished and terminate the continuation with the error:
                continuation.finish(throwing: error)
            }
        }
    }
}
