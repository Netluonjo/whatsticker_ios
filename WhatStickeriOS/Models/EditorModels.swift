import Foundation
import SwiftUI

// MARK: - Editor Tool
public enum EditorTool: String, CaseIterable, Identifiable {
    case magicCut = "Magic Cut"
    case lasso = "Freehand"
    case shape = "Shape Crop"
    case eraser = "Eraser"
    case restore = "Restore"
    case contour = "Outline"
    case text = "Text"
    case emoji = "Emoji"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .magicCut: return "wand.and.stars"
        case .lasso: return "lasso"
        case .shape: return "crop"
        case .eraser: return "eraser.fill"
        case .restore: return "paintbrush.pointed.fill"
        case .contour: return "circle.dashed"
        case .text: return "textformat"
        case .emoji: return "face.smiling"
        }
    }
}

// MARK: - Crop Shape
public enum CropShape: String, CaseIterable, Identifiable {
    case circle = "Circle"
    case rounded = "Rounded"
    case square = "Square"
    case freehand = "Freehand"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .circle: return "circle"
        case .rounded: return "app"
        case .square: return "square"
        case .freehand: return "hand.draw"
        }
    }
}

// MARK: - Text Overlay
public struct TextOverlay: Identifiable, Codable, Equatable {
    public let id: String
    public var text: String
    public var fontSize: CGFloat
    public var textColorHex: String
    public var strokeColorHex: String
    public var strokeWidth: CGFloat
    public var xOffset: CGFloat
    public var yOffset: CGFloat
    public var rotationDegrees: Double
    public var scale: CGFloat

    public init(
        id: String = UUID().uuidString,
        text: String = "MEME TEXT",
        fontSize: CGFloat = 32,
        textColorHex: String = "#FFFFFF",
        strokeColorHex: String = "#000000",
        strokeWidth: CGFloat = 3.0,
        xOffset: CGFloat = 0,
        yOffset: CGFloat = 0,
        rotationDegrees: Double = 0,
        scale: CGFloat = 1.0
    ) {
        self.id = id
        self.text = text
        self.fontSize = fontSize
        self.textColorHex = textColorHex
        self.strokeColorHex = strokeColorHex
        self.strokeWidth = strokeWidth
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.rotationDegrees = rotationDegrees
        self.scale = scale
    }
}

// MARK: - Emoji Overlay
public struct EmojiOverlay: Identifiable, Codable, Equatable {
    public let id: String
    public var emoji: String
    public var xOffset: CGFloat
    public var yOffset: CGFloat
    public var scale: CGFloat
    public var rotationDegrees: Double

    public init(
        id: String = UUID().uuidString,
        emoji: String = "🔥",
        xOffset: CGFloat = 0,
        yOffset: CGFloat = 0,
        scale: CGFloat = 1.0,
        rotationDegrees: Double = 0
    ) {
        self.id = id
        self.emoji = emoji
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.scale = scale
        self.rotationDegrees = rotationDegrees
    }
}

// MARK: - Editor History Item (for Undo/Redo)
public struct EditorHistorySnapshot: Equatable {
    public var brushSize: CGFloat
    public var outlineWidth: CGFloat
    public var outlineColorHex: String
    public var textOverlays: [TextOverlay]
    public var emojiOverlays: [EmojiOverlay]
    public var isBackgroundRemoved: Bool
}

