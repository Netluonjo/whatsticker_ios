import Foundation
import UIKit
import AVFoundation
import ImageIO
import UniformTypeIdentifiers

public final class AnimatedStickerHelper {
    public static let shared = AnimatedStickerHelper()

    private init() {}

    /// Extracts sequence of frames from a local video URL
    public func extractFrames(from videoURL: URL, maxFrames: Int = 16, completion: @escaping ([UIImage]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVAsset(url: videoURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = CGSize(width: 512, height: 512)

            let duration = CMTimeGetSeconds(asset.duration)
            guard duration > 0 else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            var frames: [UIImage] = []
            let interval = duration / Double(maxFrames)

            for i in 0..<maxFrames {
                let time = CMTime(seconds: Double(i) * interval, preferredTimescale: 600)
                if let cgImage = try? generator.copyCGImage(at: time, actualTime: nil) {
                    frames.append(UIImage(cgImage: cgImage))
                }
            }

            DispatchQueue.main.async {
                completion(frames)
            }
        }
    }

    /// Creates an animated GIF data from array of UIImages with custom FPS
    public func createAnimatedGIF(from images: [UIImage], fps: Double = 12.0) -> Data? {
        guard !images.isEmpty else { return nil }

        let frameDelay = 1.0 / max(1.0, fps)
        let fileProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFLoopCount as String: 0
            ]
        ]
        let frameProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFDelayTime as String: frameDelay
            ]
        ]

        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, UTType.gif.identifier as CFString, images.count, nil) else {
            return nil
        }

        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)

        for image in images {
            if let cgImage = image.cgImage {
                CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
            }
        }

        guard CGImageDestinationFinalize(destination) else {
            return nil
        }

        return data as Data
    }
}
