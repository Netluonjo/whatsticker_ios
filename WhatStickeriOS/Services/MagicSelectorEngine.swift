import Foundation
import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

public final class MagicSelectorEngine {
    public static let shared = MagicSelectorEngine()

    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])

    private init() {}

    /// Performs automatic person / foreground segmentation on UIImage
    public func removeBackground(from inputImage: UIImage, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let cgImage = inputImage.cgImage else {
            completion(.failure(NSError(domain: "MagicSelector", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid CGImage"])))
            return
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            if #available(iOS 17.0, *) {
                let request = VNGenerateForegroundInstanceMaskRequest()
                let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])

                do {
                    try handler.perform([request])
                    guard let result = request.results?.first else {
                        throw NSError(domain: "MagicSelector", code: -2, userInfo: [NSLocalizedDescriptionKey: "No foreground detected"])
                    }

                    let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
                    let maskCIImage = CIImage(cvPixelBuffer: maskPixelBuffer)
                    let inputCIImage = CIImage(cgImage: cgImage)

                    let blendFilter = CIFilter.blendWithMask()
                    blendFilter.inputImage = inputCIImage
                    blendFilter.maskImage = maskCIImage
                    blendFilter.backgroundImage = CIImage.empty()

                    if let outputCIImage = blendFilter.outputImage,
                       let outputCGImage = self.ciContext.createCGImage(outputCIImage, from: inputCIImage.extent) {
                        let finalImage = UIImage(cgImage: outputCGImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                        DispatchQueue.main.async { completion(.success(finalImage)) }
                        return
                    }
                } catch {
                    // Fall back to legacy person segmentation
                }
            }

            // Fallback for iOS 15/16: VNGeneratePersonSegmentationRequest
            let personRequest = VNGeneratePersonSegmentationRequest()
            personRequest.qualityLevel = .accurate
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            do {
                try handler.perform([personRequest])
                guard let mask = personRequest.results?.first else {
                    throw NSError(domain: "MagicSelector", code: -3, userInfo: [NSLocalizedDescriptionKey: "Segmentation failed"])
                }

                let maskCIImage = CIImage(cvPixelBuffer: mask.pixelBuffer)
                let inputCIImage = CIImage(cgImage: cgImage)

                let scaleX = inputCIImage.extent.width / maskCIImage.extent.width
                let scaleY = inputCIImage.extent.height / maskCIImage.extent.height
                let scaledMask = maskCIImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

                let blendFilter = CIFilter.blendWithMask()
                blendFilter.inputImage = inputCIImage
                blendFilter.maskImage = scaledMask
                blendFilter.backgroundImage = CIImage.empty()

                if let outputCIImage = blendFilter.outputImage,
                   let outputCGImage = self.ciContext.createCGImage(outputCIImage, from: inputCIImage.extent) {
                    let finalImage = UIImage(cgImage: outputCGImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                    DispatchQueue.main.async { completion(.success(finalImage)) }
                } else {
                    throw NSError(domain: "MagicSelector", code: -4, userInfo: [NSLocalizedDescriptionKey: "Rendering failed"])
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
}
