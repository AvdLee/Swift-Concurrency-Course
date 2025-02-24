//
//  ImageContentView.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import SwiftUI

struct ImageContentView: View {
    @State private var image: UIImage?
    
    let imageFetcher = ImageFetcher()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image {
                    Image(uiImage: image)
                } else {
                    Text("Loading...")
                }
            }.navigationTitle("Image Fetching Example")
                .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            do {
                image = try await imageFetcher.fetchImage()
                print("Image loading completed")
            } catch {
                print("Image loading failed: \(error)")
            }
        }
    }
}
