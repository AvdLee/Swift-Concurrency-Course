//
//  GoodGradientWallpaperGenerator.swift
//  ConcurrencyPerformance
//
//  Created by A.J. van der Lee on 11/11/2025.
//

import CoreGraphics
import Foundation

/// Generates random "mesh gradient" style wallpapers as CGImage.
nonisolated struct GoodGradientWallpaperGenerator {
    public let width: Int
    public let height: Int
    public let controlPointCount: Int
    public let nearestPointsToSample: Int

    private struct ControlPoint {
        let x: Double   // 0...1
        let y: Double   // 0...1
        let r: Double   // 0...1
        let g: Double   // 0...1
        let b: Double   // 0...1
        let a: Double   // 0...1
    }

    init(
        width: Int = 1024,
        height: Int = 1024,
        controlPointCount: Int = 8,
        nearestPointsToSample: Int = 4
    ) {
        precondition(width > 0 && height > 0, "Width/height must be positive")
        precondition(controlPointCount >= 2, "Need at least 2 control points")
        precondition(nearestPointsToSample >= 1, "Sample at least one point")
        self.width = width
        self.height = height
        self.controlPointCount = controlPointCount
        self.nearestPointsToSample = min(nearestPointsToSample, controlPointCount)
    }

    /// Generates a new random mesh gradient image.
    func generate() -> CGImage {
        let controlPoints = generateRandomControlPoints()

        // RGBA, 8 bits per component
        var pixels = [UInt8](repeating: 0, count: width * height * 4)

        for y in 0..<height {
            let v = Double(y) / Double(height - 1)

            for x in 0..<width {
                let u = Double(x) / Double(width - 1)

                let (r, g, b, a) = colorAt(u: u, v: v, controlPoints: controlPoints)

                let index = (y * width + x) * 4
                pixels[index + 0] = UInt8(clamping: Int(r * 255.0))
                pixels[index + 1] = UInt8(clamping: Int(g * 255.0))
                pixels[index + 2] = UInt8(clamping: Int(b * 255.0))
                pixels[index + 3] = UInt8(clamping: Int(a * 255.0))
            }
        }

        // Build CGImage from raw pixel buffer
        let data = Data(pixels)
        guard let provider = CGDataProvider(data: data as CFData) else {
            fatalError("Failed to create CGDataProvider")
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        guard let image = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            fatalError("Failed to create CGImage")
        }

        return image
    }

    // MARK: - Private helpers

    private func generateRandomControlPoints() -> [ControlPoint] {
        var rng = SystemRandomNumberGenerator()
        var points: [ControlPoint] = []
        points.reserveCapacity(controlPointCount)

        for _ in 0..<controlPointCount {
            let x = Double.random(in: 0...1, using: &rng)
            let y = Double.random(in: 0...1, using: &rng)

            // Favor saturated, brightish colors for nicer gradients
            let hue = Double.random(in: 0...1, using: &rng)
            let saturation = Double.random(in: 0.6...1.0, using: &rng)
            let brightness = Double.random(in: 0.7...1.0, using: &rng)

            let (r, g, b) = hsbToRGB(h: hue, s: saturation, b: brightness)

            let alpha = 1.0

            points.append(ControlPoint(x: x, y: y, r: r, g: g, b: b, a: alpha))
        }

        return points
    }

    /// Inverse-distance weighted blending of nearest control points.
    private func colorAt(
        u: Double,
        v: Double,
        controlPoints: [ControlPoint]
    ) -> (Double, Double, Double, Double) {
        let px = u
        let py = v

        // Sort control points by distance and take the nearest N
        let nearest = controlPoints
            .sorted { lhs, rhs in
                let d2L = squaredDistance(px, py, lhs.x, lhs.y)
                let d2R = squaredDistance(px, py, rhs.x, rhs.y)
                return d2L < d2R
            }
            .prefix(nearestPointsToSample)

        var rSum = 0.0
        var gSum = 0.0
        var bSum = 0.0
        var aSum = 0.0
        var weightSum = 0.0

        for p in nearest {
            let d2 = squaredDistance(px, py, p.x, p.y)
            // Avoid division by zero and explode less near the point
            let w = 1.0 / max(d2, 1e-4)

            rSum += p.r * w
            gSum += p.g * w
            bSum += p.b * w
            aSum += p.a * w
            weightSum += w
        }

        let invW = 1.0 / max(weightSum, 1e-8)
        return (rSum * invW, gSum * invW, bSum * invW, aSum * invW)
    }

    private func squaredDistance(
        _ x1: Double, _ y1: Double,
        _ x2: Double, _ y2: Double
    ) -> Double {
        let dx = x1 - x2
        let dy = y1 - y2
        return dx * dx + dy * dy
    }

    /// Simple HSB → RGB conversion for nicer random colors.
    private func hsbToRGB(h: Double, s: Double, b: Double) -> (Double, Double, Double) {
        if s == 0 {
            return (b, b, b)
        }

        let hue = (h.truncatingRemainder(dividingBy: 1) + 1).truncatingRemainder(dividingBy: 1) * 6
        let i = Int(hue)
        let f = hue - Double(i)
        let p = b * (1 - s)
        let q = b * (1 - s * f)
        let t = b * (1 - s * (1 - f))

        switch i {
        case 0: return (b, t, p)
        case 1: return (q, b, p)
        case 2: return (p, b, t)
        case 3: return (p, q, b)
        case 4: return (t, p, b)
        default: return (b, p, q)
        }
    }
}
