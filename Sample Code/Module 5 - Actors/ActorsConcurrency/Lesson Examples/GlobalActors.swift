//
//  GlobalActors.swift
//  ActorsConcurrency
//
//  Created by A.J. van der Lee on 25/03/2025.
//

import Foundation
import SwiftUI

@MainActor
private final class ContentViewModel {
    
    var titles: [String] = []
    
    /// ...
}

@globalActor public enum ImageProcessing {
    public actor TheActor {}
    public static let shared = TheActor()
}

@ImageProcessing
final class ImageCache {
    
    var images: [URL: Data] = [:]
    
    /// Image cache logic...
}

@ImageProcessing
func applyFilter(_ inputImage: Image) -> Image {
    /// Apply filter to an image
    
    /// Returning input image for the sake of this example.
    return inputImage
}
