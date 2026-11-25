import Foundation
import SwiftUI

// MARK: - Sticker Category
public enum StickerCategory: String, CaseIterable, Identifiable, Codable {
    case all = "All"
    case memes = "Memes"
    case cute = "Cute"
    case reactions = "Reactions"
    case animals = "Animals"
    case anime = "Anime"
    case love = "Love"
    case gaming = "Gaming"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .all: return "sparkles"
        case .memes: return "face.smiling.inverse"
        case .cute: return "heart.circle.fill"
        case .reactions: return "bolt.heart.fill"
        case .animals: return "pawprint.fill"
        case .anime: return "wand.and.stars"
        case .love: return "flame.fill"
        case .gaming: return "gamecontroller.fill"
        }
    }
}

// MARK: - Sticker Item
public struct StickerItem: Identifiable, Codable, Equatable {
    public let id: String
    public var name: String
    public var imageData: Data?
    public var imageSymbol: String
    public var symbolColor: String
    public var emojis: [String]
    public var isAnimated: Bool
    public var frameCount: Int
    public var fps: Double
    public var topCaption: String?
    public var bottomCaption: String?
    public var createdAt: Date

    public init(
        id: String = UUID().uuidString,
        name: String = "Sticker",
        imageData: Data? = nil,
        imageSymbol: String = "sparkle",
        symbolColor: String = "#FF5252",
        emojis: [String] = ["✨"],
        isAnimated: Bool = false,
        frameCount: Int = 1,
        fps: Double = 12.0,
        topCaption: String? = nil,
        bottomCaption: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.imageSymbol = imageSymbol
        self.symbolColor = symbolColor
        self.emojis = emojis
        self.isAnimated = isAnimated
        self.frameCount = frameCount
        self.fps = fps
        self.topCaption = topCaption
        self.bottomCaption = bottomCaption
        self.createdAt = createdAt
    }
}

// MARK: - Sticker Pack
public struct StickerPack: Identifiable, Codable, Equatable {
    public let id: String
    public var title: String
    public var author: String
    public var authorAvatarSymbol: String
    public var isVerified: Bool
    public var packCode: String
    public var stickers: [StickerItem]
    public var category: StickerCategory
    public var downloadsCount: Int
    public var likesCount: Int
    public var isAnimated: Bool
    public var isVipOnly: Bool
    public var isFavorite: Bool
    public var isInstalled: Bool
    public var trayImageSymbol: String

    public init(
        id: String = UUID().uuidString,
        title: String,
        author: String = "WhatSticker Creator",
        authorAvatarSymbol: String = "person.crop.circle.fill",
        isVerified: Bool = true,
        packCode: String = "WS-" + UUID().uuidString.prefix(4).uppercased(),
        stickers: [StickerItem] = [],
        category: StickerCategory = .memes,
        downloadsCount: Int = 12500,
        likesCount: Int = 3400,
        isAnimated: Bool = false,
        isVipOnly: Bool = false,
        isFavorite: Bool = false,
        isInstalled: Bool = false,
        trayImageSymbol: String = "face.smiling.fill"
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.authorAvatarSymbol = authorAvatarSymbol
        self.isVerified = isVerified
        self.packCode = packCode
        self.stickers = stickers
        self.category = category
        self.downloadsCount = downloadsCount
        self.likesCount = likesCount
        self.isAnimated = isAnimated
        self.isVipOnly = isVipOnly
        self.isFavorite = isFavorite
        self.isInstalled = isInstalled
        self.trayImageSymbol = trayImageSymbol
    }
}

// MARK: - Meme Template
public struct MemeTemplate: Identifiable, Codable, Equatable {
    public let id: String
    public var name: String
    public var category: String
    public var defaultTopText: String
    public var defaultBottomText: String
    public var symbolIcon: String
    public var accentColorHex: String

    public init(
        id: String,
        name: String,
        category: String,
        defaultTopText: String,
        defaultBottomText: String,
        symbolIcon: String = "quote.bubble.fill",
        accentColorHex: String = "#FF6B6B"
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.defaultTopText = defaultTopText
        self.defaultBottomText = defaultBottomText
        self.symbolIcon = symbolIcon
        self.accentColorHex = accentColorHex
    }
}

// MARK: - User Profile
public struct UserProfile: Identifiable, Codable, Equatable {
    public let id: String
    public var name: String
    public var handle: String
    public var bio: String
    public var avatarSymbol: String
    public var followersCount: Int
    public var followingCount: Int
    public var isVerified: Bool
    public var isVip: Bool
    public var websiteUrl: String
    public var socialLinks: [String: String]

    public init(
        id: String = UUID().uuidString,
        name: String = "Alex Rivera",
        handle: String = "@alex_stickers",
        bio: String = "✨ Professional meme creator & sticker artisan. Creating joy 1 sticker at a time!",
        avatarSymbol: String = "sparkles.rectangle.stack.fill",
        followersCount: Int = 14200,
        followingCount: Int = 380,
        isVerified: Bool = true,
        isVip: Bool = true,
        websiteUrl: String = "https://whatsticker.app/u/alex",
        socialLinks: [String: String] = [
            "instagram": "alex_stickers",
            "tiktok": "alex_stickers",
            "twitter": "alex_art"
        ]
    ) {
        self.id = id
        self.name = name
        self.handle = handle
        self.bio = bio
        self.avatarSymbol = avatarSymbol
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.isVerified = isVerified
        self.isVip = isVip
        self.websiteUrl = websiteUrl
        self.socialLinks = socialLinks
    }
}

