import Foundation
import SwiftUI

public struct PresetData {

    // MARK: - Meme Templates
    public static let memeTemplates: [MemeTemplate] = [
        MemeTemplate(
            id = "meme_drake",
            name: "Drake Hotline Bling",
            category: "Classic",
            defaultTopText: "Texting with plain words",
            defaultBottomText: "Sending WhatSticker stickers",
            symbolIcon: "hand.raised.slash.fill",
            accentColorHex: "#FF9F43"
        ),
        MemeTemplate(
            id = "meme_distracted",
            name: "Distracted Boyfriend",
            category: "Classic",
            defaultTopText: "Me",
            defaultBottomText: "New sticker pack",
            symbolIcon: "eyes",
            accentColorHex: "#EE5253"
        ),
        MemeTemplate(
            id = "meme_doge_cheems",
            name: "Buff Doge vs Cheems",
            category: "Animals",
            defaultTopText: "Me in 2012 making memes",
            defaultBottomText: "Me today with AI sticker maker",
            symbolIcon: "pawprint.fill",
            accentColorHex: "#F368E0"
        ),
        MemeTemplate(
            id = "meme_woman_cat",
            name: "Woman Yelling at Cat",
            category: "Animals",
            defaultTopText: "You didn't reply for 5 minutes!",
            defaultBottomText: "Me making stickers",
            symbolIcon: "exclamationmark.bubble.fill",
            accentColorHex: "#0ABDE3"
        ),
        MemeTemplate(
            id = "meme_pikachu",
            name: "Surprised Pikachu",
            category: "Reactions",
            defaultTopText: "Exports sticker to WhatsApp",
            defaultBottomText: "Entire group chat: 😲",
            symbolIcon: "bolt.fill",
            accentColorHex: "#FFD32A"
        ),
        MemeTemplate(
            id = "meme_trade_offer",
            name: "Trade Offer",
            category: "Trending",
            defaultTopText: "I receive: A funny selfie",
            defaultBottomText: "You receive: A top tier sticker",
            symbolIcon: "arrow.triangle.2.circlepath",
            accentColorHex: "#10AC84"
        ),
        MemeTemplate(
            id = "meme_gigachad",
            name: "GigaChad",
            category: "Trending",
            defaultTopText: "Average sticker user",
            defaultBottomText: "Average sticker creator",
            symbolIcon: "crown.fill",
            accentColorHex: "#576574"
        ),
        MemeTemplate(
            id = "meme_this_is_fine",
            name: "This is Fine",
            category: "Reactions",
            defaultTopText: "Deadline is in 10 minutes",
            defaultBottomText: "Me making custom stickers",
            symbolIcon: "flame.fill",
            accentColorHex: "#FF6B6B"
        ),
        MemeTemplate(
            id = "meme_expanding_brain",
            name: "Expanding Brain",
            category: "Classic",
            defaultTopText: "Sending text",
            defaultBottomText: "Sending animated 4K sticker",
            symbolIcon: "brain.head.profile",
            accentColorHex: "#54A0FF"
        )
    ]

    // MARK: - Preset Packs
    public static let initialPacks: [StickerPack] = [
        StickerPack(
            id: "pack_trending_memes",
            title: "Viral Meme Hall of Fame",
            author: "MemeLord99",
            authorAvatarSymbol: "flame.circle.fill",
            isVerified: true,
            packCode: "WS-MEME",
            stickers: [
                StickerItem(name: "Doge Wow", imageSymbol: "pawprint.fill", symbolColor: "#FF9F43", emojis: ["🐶", "🚀"]),
                StickerItem(name: "Giga Chad", imageSymbol: "crown.fill", symbolColor: "#576574", emojis: ["🗿", "💪"]),
                StickerItem(name: "Fine Fire", imageSymbol: "flame.fill", symbolColor: "#EE5253", emojis: ["🔥", "☕"]),
                StickerItem(name: "Shock Face", imageSymbol: "bolt.fill", symbolColor: "#FFD32A", emojis: ["⚡", "😱"]),
                StickerItem(name: "Big Brain", imageSymbol: "brain.head.profile", symbolColor: "#54A0FF", emojis: ["🧠", "💡"]),
                StickerItem(name: "Stonks Up", imageSymbol: "chart.line.uptrend.xyaxis", symbolColor: "#10AC84", emojis: ["📈", "💰"])
            ],
            category: .memes,
            downloadsCount: 48920,
            likesCount: 15300,
            isAnimated: false,
            isVipOnly: false,
            trayImageSymbol: "flame.fill"
        ),
        StickerPack(
            id: "pack_cute_capybara",
            title: "Chill Capybara Moments",
            author: "ZooStudio",
            authorAvatarSymbol: "leaf.circle.fill",
            isVerified: true,
            packCode: "WS-CAPY",
            stickers: [
                StickerItem(name: "Hot Tub Chill", imageSymbol: "bathtub.fill", symbolColor: "#FF9F43", emojis: ["🍊", "🛀"]),
                StickerItem(name: "Orange Hat", imageSymbol: "leaf.fill", symbolColor: "#10AC84", emojis: ["🍊", "👒"]),
                StickerItem(name: "Nap Time", imageSymbol: "moon.zzz.fill", symbolColor: "#5F27CD", emojis: ["😴", "💤"]),
                StickerItem(name: "Munching Grass", imageSymbol: "fork.knife", symbolColor: "#00D2D3", emojis: ["🌿", "😋"]),
                StickerItem(name: "Capy Hug", imageSymbol: "heart.fill", symbolColor: "#FF6B6B", emojis: ["💖", "🫂"]),
                StickerItem(name: "Sunglasses Cool", imageSymbol: "sunglasses.fill", symbolColor: "#222F3E", emojis: ["😎", "🕶️"])
            ],
            category: .cute,
            downloadsCount: 36400,
            likesCount: 11200,
            isAnimated: true,
            isVipOnly: false,
            trayImageSymbol: "leaf.fill"
        ),
        StickerPack(
            id: "pack_anime_chibi",
            title: "Chibi Anime Emotions",
            author: "TokyoKawai",
            authorAvatarSymbol: "wand.and.stars.inverse",
            isVerified: true,
            packCode: "WS-CHIB",
            stickers: [
                StickerItem(name: "Sparkle Eyes", imageSymbol: "sparkles", symbolColor: "#F368E0", emojis: ["✨", "🥺"]),
                StickerItem(name: "Rage Pout", imageSymbol: "smoke.fill", symbolColor: "#FF5252", emojis: ["😤", "💢"]),
                StickerItem(name: "Boba Drink", imageSymbol: "cup.and.saucer.fill", symbolColor: "#8395A7", emojis: ["🧋", "😋"]),
                StickerItem(name: "Victory Sign", imageSymbol: "hand.thumbsup.fill", symbolColor: "#FF9F43", emojis: ["✌️", "🎉"]),
                StickerItem(name: "Dumbfounded", imageSymbol: "questionmark.circle.fill", symbolColor: "#54A0FF", emojis: ["❓", "😵"]),
                StickerItem(name: "Tears of Joy", imageSymbol: "drop.fill", symbolColor: "#0ABDE3", emojis: ["😭", "💖"])
            ],
            category: .anime,
            downloadsCount: 52100,
            likesCount: 18900,
            isAnimated: true,
            isVipOnly: true,
            trayImageSymbol: "sparkles"
        ),
        StickerPack(
            id: "pack_office_daily",
            title: "Corporate Survival Kit",
            author: "WorkLifeCrisis",
            authorAvatarSymbol: "briefcase.fill",
            isVerified: false,
            packCode: "WS-WORK",
            stickers: [
                StickerItem(name: "Need Coffee", imageSymbol: "mug.fill", symbolColor: "#8395A7", emojis: ["☕", "💀"]),
                StickerItem(name: "Meeting Overload", imageSymbol: "person.3.fill", symbolColor: "#EE5253", emojis: ["📅", "🤯"]),
                StickerItem(name: "Friday Escape", imageSymbol: "figure.run", symbolColor: "#10AC84", emojis: ["🏃", "🚪"]),
                StickerItem(name: "Per My Email", imageSymbol: "envelope.fill", symbolColor: "#2E86DE", emojis: ["✉️", "🙃"])
            ],
            category: .reactions,
            downloadsCount: 19800,
            likesCount: 6400,
            isAnimated: false,
            isVipOnly: false,
            trayImageSymbol: "briefcase.fill"
        )
    ]
}
