import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

public final class StickerProcessor {
    public static let shared = StickerProcessor()

    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])

    private init() {}

    /// Adds a white or colored die-cut outline around the transparent subject
    public func addStickerContour(
        to image: UIImage,
        outlineWidth: CGFloat = 8.0,
        outlineColor: UIColor = .white
    ) -> UIImage {
        guard outlineWidth > 0 else { return image }
        guard let cgImage = image.cgImage else { return image }

        let padding = outlineWidth * 2
        let newWidth = image.size.width + padding * 2
        let newHeight = image.size.height + padding * 2

        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return image
        }

        let drawRect = CGRect(x: padding, y: padding, width: image.size.width, height: image.size.height)

        // Draw shadow / dilated stroke
        context.saveGState()
        context.setShadow(offset: .zero, blur: outlineWidth, color: outlineColor.cgColor)
        for dx in stride(from: -outlineWidth, through: outlineWidth, by: max(1, outlineWidth / 4)) {
            for dy in stride(from: -outlineWidth, through: outlineWidth, by: max(1, outlineWidth / 4)) {
                if dx * dx + dy * dy <= outlineWidth * outlineWidth {
                    image.draw(in: drawRect.offsetBy(dx: dx, dy: dy), blendMode: .destinationOver, alpha: 1.0)
                }
            }
        }
        context.restoreGState()

        // Draw original subject on top
        image.draw(in: drawRect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resultImage ?? image
    }

    /// Renders the complete composite sticker including text overlays and emoji layers
    public func renderCompositeSticker(
        baseImage: UIImage?,
        symbolIcon: String,
        symbolColor: UIColor,
        outlineWidth: CGFloat,
        outlineColor: UIColor,
        textOverlays: [TextOverlay],
        emojiOverlays: [EmojiOverlay],
        targetSize: CGSize = CGSize(width: 512, height: 512)
    ) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }

        // Draw base or symbol
        if let base = baseImage {
            let processedBase = addStickerContour(to: base, outlineWidth: outlineWidth, outlineColor: outlineColor)
            let aspectRect = AVMakeRect(aspectRatio: processedBase.size, insideRect: CGRect(origin: .zero, size: targetSize))
            processedBase.draw(in: aspectRect)
        } else {
            // Draw vector SF Symbol with circular badge
            let bgCircle = CGRect(x: 32, y: 32, width: targetSize.width - 64, height: targetSize.height - 64)
            context.setFillColor(symbolColor.withAlphaComponent(0.2).cgColor)
            context.fillEllipse(in: bgCircle)
            context.setStrokeColor(symbolColor.cgColor)
            context.setLineWidth(outlineWidth > 0 ? outlineWidth : 4)
            context.strokeEllipse(in: bgCircle)

            let config = UIImage.SymbolConfiguration(pointSize: 180, weight: .bold)
            if let sfSymbol = UIImage(systemName: symbolIcon, withConfiguration: config)?.withTintColor(symbolColor, renderingMode: .alwaysOriginal) {
                let symbolRect = CGRect(x: (targetSize.width - 180) / 2, y: (targetSize.height - 180) / 2, width: 180, height: 180)
                sfSymbol.draw(in: symbolRect)
            }
        }

        // Draw Emoji Overlays
        for emoji in emojiOverlays {
            let emojiString = emoji.emoji as NSString
            let fontSize = 64 * emoji.scale
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize)
            ]
            let size = emojiString.size(withAttributes: attributes)
            let drawPoint = CGPoint(
                x: targetSize.width / 2 + emoji.xOffset - size.width / 2,
                y: targetSize.height / 2 + emoji.yOffset - size.height / 2
            )
            emojiString.draw(at: drawPoint, withAttributes: attributes)
        }

        // Draw Text Overlays
        for textOverlay in textOverlays {
            let text = textOverlay.text as NSString
            let font = UIFont.systemFont(ofSize: textOverlay.fontSize * textOverlay.scale, weight: .heavy)
            let textColor = UIColor(hex: textOverlay.textColorHex) ?? .white
            let strokeColor = UIColor(hex: textOverlay.strokeColorHex) ?? .black

            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .strokeColor: strokeColor,
                .strokeWidth: -textOverlay.strokeWidth * 2
            ]

            let textSize = text.size(withAttributes: textAttributes)
            let point = CGPoint(
                x: targetSize.width / 2 + textOverlay.xOffset - textSize.width / 2,
                y: targetSize.height / 2 + textOverlay.yOffset - textSize.height / 2
            )
            text.draw(at: point, withAttributes: textAttributes)
        }

        let result = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return result
    }
}

// MARK: - Color Hex Extension
extension UIColor {
    convenience init?(hex: String) {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanHex.hasPrefix("#") { cleanHex.removeFirst() }
        guard cleanHex.count == 6, let rgb = UInt32(cleanHex, radix: 16) else { return nil }
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}

extension Color {
    init(hex: String) {
        let cleanHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleanHex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

