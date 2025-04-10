//
//  ContentView.swift
//  AsyncSequencesConcurrency
//
//  Created by A.J. van der Lee on 10/04/2025.
//

import SwiftUI

#if os(macOS)
import AppKit
typealias PlatformImage = NSImage
#else
import UIKit
typealias PlatformImage = UIImage
#endif

struct ContentView: View {
    
    private let asyncSequenceDemonstrator = AsyncSequenceDemonstrator()
    private let asyncStreamDemonstrator = AsyncStreamDemonstrator()
    private let locationStreamingDemonstrator = LocationStreamingDemonstrator()
    private let pingServiceDemonstrator = PingServiceDemonstrator()
    
    @State private var image: PlatformImage?
    
    var body: some View {
        Form {
            Section("AsyncSequence") {
                Button("Demonstrate AsyncSequence") {
                    Task {
                        await asyncSequenceDemonstrator.demonstrate()
                    }
                }
            }
            Section("AsyncStream") {
                if let image {
#if os(macOS)
                    Image(nsImage: image)
#else
                    Image(uiImage: image)
#endif
                }
                Button("Demonstrate File Download") {
                    Task {
                        do {
                            let imageData = try await asyncStreamDemonstrator.demonstrateFileDownloading()
                            image = PlatformImage(data: imageData)
                        } catch {
                            print("Image downloading failed.")
                        }
                    }
                }
                Button("Demonstrate AsyncStream Cancellation") {
                    asyncStreamDemonstrator.demonstrateCancellation()
                }
                Button("Demonstrate Single Consumer") {
                    asyncStreamDemonstrator.demonstrateSingleConsumer()
                }
                Button("Demonstrate no more values after Termination") {
                    Task {
                        await asyncStreamDemonstrator.demonstrateTermination()
                    }
                }
                Button("Demonstrate buffer policy") {
                    Task {
                        await asyncStreamDemonstrator.demonstrateBufferPolicy()
                    }
                }
                
            }
            Section("Real World Examples") {
                Button("Demonstrate Location Streaming") {
                    Task {
                        await locationStreamingDemonstrator.demonstrate()
                    }
                }
                Button("Demonstrate Ping Service") {
                    Task {
                        await pingServiceDemonstrator.demonstrate()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
