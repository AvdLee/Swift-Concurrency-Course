//
//  ImageContentView.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 24/02/2025.
//

import SwiftUI

struct ImageContentView: View {
    @State private var image: UIImage?
    @State private var taskGroupImages: [UIImage] = []
    
    let imageFetcher = ImageFetcher()
    let taskGroupsDemonstrator = TaskGroupsDemonstrator()

    var body: some View {
        NavigationStack {
            List {
                /// Single image loading.
                Section {
                    Group {
                        if let image {
                            Image(uiImage: image)
                        } else {
                            Text("Loading...")
                        }
                    }
                } header: {
                    Text("Single image")
                }
                
                /// Multiple images loading using Task Groups.
                Section {
                    if !taskGroupImages.isEmpty {
                        ForEach(taskGroupImages, id: \.self) { image in
                            Image(uiImage: image)
                        }
                    } else {
                        Text("Loading...")
                    }
                } header: {
                    Text("Multiple images using Task Groups")
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
        .task {
            do {
                taskGroupImages = try await taskGroupsDemonstrator.fetchImages()
            } catch {
                print("Task group image loading failed: \(error)")
            }
        }
    }
}
