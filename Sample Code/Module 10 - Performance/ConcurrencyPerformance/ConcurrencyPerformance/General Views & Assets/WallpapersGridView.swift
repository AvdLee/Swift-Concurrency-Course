//
//  WallpapersGridView.swift
//  ConcurrencyPerformance
//
//  Created by A.J. van der Lee on 11/11/2025.
//

import SwiftUI

struct WallpapersGridView: View {
    let wallpapers: [Wallpaper]

    // Two equal-width columns
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(wallpapers) { wallpaper in
                #if os(macOS)
                Image(nsImage: NSImage(cgImage: wallpaper.image, size: CGSize(width: wallpaper.image.width, height: wallpaper.image.height)))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(12)
                #else
                Image(uiImage: UIImage(cgImage: wallpaper.image))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(12)
                #endif
            }
        }
        .padding()
    }
}
