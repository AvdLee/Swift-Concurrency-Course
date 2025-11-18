//
//  GradientsGeneratorView.swift
//  ConcurrencyPerformance
//
//  Created by A.J. van der Lee on 11/11/2025.
//

import SwiftUI

@MainActor
@Observable
final class BadGradientsGeneratorViewModel {
    let numberOfWallpapersToGenerate = 100
    var wallpapers: [Wallpaper] = []
    var isGenerating: Bool = false
    
    let wallpapersGenerator = WallpapersGenerator()
    
    func regenerateWallpapers() {
        regenerateWallpapers_v5()
    }
    
    func regenerateWallpapers_v1() {
        wallpapers.removeAll()
        isGenerating = true
        
        Task {
            for _ in 0..<numberOfWallpapersToGenerate {
                let generator = BadGradientWallpaperGenerator(
                    width: 640,
                    height: 360,
                    controlPointCount: 2,
                    nearestPointsToSample: 1
                )

                let image = generator.generate()
                wallpapers.insert(Wallpaper(image: image), at: 0)
                
                if self.wallpapers.count == self.numberOfWallpapersToGenerate {
                    self.isGenerating = false
                }
            }
        }
    }
    
    func regenerateWallpapers_v2() {
        wallpapers.removeAll()
        isGenerating = true
        
        Task {
            for _ in 0..<numberOfWallpapersToGenerate {
                let wallpaper = await wallpapersGenerator.generate()
                wallpapers.insert(wallpaper, at: 0)
                
                if self.wallpapers.count == self.numberOfWallpapersToGenerate {
                    self.isGenerating = false
                }
            }
        }
    }
    
    func regenerateWallpapers_v3() {
        wallpapers.removeAll()
        isGenerating = true
        
        Task {
            await withTaskGroup { group in
                for index in 0..<numberOfWallpapersToGenerate {
                    group.addTask(name: "Wallpaper \(index)") {
                        let wallpaper = await self.wallpapersGenerator.generate()
                        return wallpaper
                    }
                }
                
                for await wallpaper in group {
                    wallpapers.insert(wallpaper, at: 0)
                    
                    if self.wallpapers.count == self.numberOfWallpapersToGenerate {
                        self.isGenerating = false
                    }
                }
            }
        }
    }
    
    func regenerateWallpapers_v4() {
        wallpapers.removeAll()
        isGenerating = true
        
        for index in 0..<numberOfWallpapersToGenerate {
            Task(name: "Wallpaper \(index)") {
                /// Task State 1: Running
                /// Task State 2: Suspended to go into `ConcurrentWallpaperGenerator`
                /// Task State 3: Running while inside `ConcurrentWallpaperGenerator.generate()`
                let wallpaper = await ConcurrentWallpaperGenerator.generate()
                /// Task State 4: Suspended to go back into this `@MainActor` isolation domain.
                /// Task State 5: Running while inserting the wallpaper into `BadGradientsGeneratorViewModel`
                
                self.wallpapers.insert(wallpaper, at: 0)
                
                if self.wallpapers.count == self.numberOfWallpapersToGenerate {
                    self.isGenerating = false
                }
            }
        }
    }
    
    func regenerateWallpapers_v5() {
        wallpapers.removeAll()
        isGenerating = true
        
        for index in 0..<numberOfWallpapersToGenerate {
            Task(name: "Wallpaper \(index)") { @concurrent in
                let wallpaper = SynchronousWallpaperGenerator.generate()
                
                await MainActor.run {
                    self.wallpapers.insert(wallpaper, at: 0)
                    
                    if self.wallpapers.count == self.numberOfWallpapersToGenerate {
                        self.isGenerating = false
                    }
                }
            }
        }
    }
}

nonisolated struct SynchronousWallpaperGenerator {
    static func generate() -> Wallpaper {
        let generator = BadGradientWallpaperGenerator(
            width: 640,
            height: 360,
            controlPointCount: 2,
            nearestPointsToSample: 1
        )
        
        let image = generator.generate()
        return Wallpaper(image: image)
    }
}

struct ConcurrentWallpaperGenerator {
    @concurrent
    static func generate() async -> Wallpaper {
        let generator = BadGradientWallpaperGenerator(
            width: 640,
            height: 360,
            controlPointCount: 2,
            nearestPointsToSample: 1
        )
        
        let image = generator.generate()
        return Wallpaper(image: image)
    }
}

actor WallpapersGenerator {
    func generate() -> Wallpaper {
        let generator = BadGradientWallpaperGenerator(
            width: 640,
            height: 360,
            controlPointCount: 2,
            nearestPointsToSample: 1
        )
        
        let image = generator.generate()
        return Wallpaper(image: image)
    }
}

struct BadGradientsGeneratorView: View {
    
    let viewModel = BadGradientsGeneratorViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                if viewModel.isGenerating {
                    VStack(spacing: 8) {
                        Text("Generating wallpapers...")
                        ProgressView(
                            value: Double(viewModel.wallpapers.count),
                            total: Double(viewModel.numberOfWallpapersToGenerate)
                        )
                    }
                    .padding()
                }
                
                WallpapersGridView(wallpapers: viewModel.wallpapers)
                    // Make room so the last row isn’t hidden behind the button
                    .padding(.bottom, 80)
            }
            
            generateButton
        }
    }
    
    private var generateButton: some View {
        Button {
            viewModel.regenerateWallpapers()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "paintbrush.pointed")
                Text(viewModel.isGenerating ? "Generating…" : "Generate Wallpapers")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .font(.headline)
        }
        .background(
            // Works on macOS & iOS; gives a nice floating look. Works < iOS & macOS 26.
            .regularMaterial
        )
        .clipShape(Capsule())
        .shadow(radius: 8)
        .padding(.bottom, 24)
        .padding(.horizontal)
        .disabled(viewModel.isGenerating)
        .opacity(viewModel.isGenerating ? 0.7 : 1.0)
    }
}

#Preview {
    BadGradientsGeneratorView()
}
