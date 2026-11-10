import Foundation
import Combine

public final class StickerRepository: ObservableObject {
    public static let shared = StickerRepository()

    @Published public var myPacks: [StickerPack] = []
    @Published public var explorePacks: [StickerPack] = []
    @Published public var memeTemplates: [MemeTemplate] = []
    @Published public var userProfile: UserProfile = UserProfile()

    private let myPacksKey = "com.whatsticker.ios.mypacks"

    public init() {
        self.memeTemplates = PresetData.memeTemplates
        self.explorePacks = PresetData.initialPacks
        loadSavedPacks()
    }

    // MARK: - Persistence
    private func loadSavedPacks() {
        if let data = UserDefaults.standard.data(forKey: myPacksKey),
           let decoded = try? JSONDecoder().decode([StickerPack].self, from: data), !decoded.isEmpty {
            self.myPacks = decoded
        } else {
            // Seed 1 starter pack for user
            let starterPack = StickerPack(
                id: "pack_my_first",
                title: "My Custom Creations",
                author: "Alex Rivera",
                authorAvatarSymbol: "person.crop.circle.fill",
                isVerified: false,
                packCode: "WS-MINE",
                stickers: [
                    StickerItem(name: "Hello Star", imageSymbol: "star.fill", symbolColor: "#FFD32A", emojis: ["⭐"]),
                    StickerItem(name: "Fire Cool", imageSymbol: "flame.fill", symbolColor: "#FF5252", emojis: ["🔥"]),
                    StickerItem(name: "Heart Love", imageSymbol: "heart.fill", symbolColor: "#FF6B6B", emojis: ["❤️"])
                ],
                category: .memes,
                downloadsCount: 1,
                likesCount: 1,
                isAnimated: false,
                trayImageSymbol: "star.fill"
            )
            self.myPacks = [starterPack]
            savePacks()
        }
    }

    public func savePacks() {
        if let encoded = try? JSONEncoder().encode(myPacks) {
            UserDefaults.standard.set(encoded, forKey: myPacksKey)
        }
    }

    // MARK: - Pack CRUD
    public func createPack(title: String, category: StickerCategory = .memes, isAnimated: Bool = false) -> StickerPack {
        let code = "WS-" + String(Int.random(in: 1000...9999))
        let newPack = StickerPack(
            title: title,
            author: userProfile.name,
            authorAvatarSymbol: "person.crop.circle.fill",
            isVerified: false,
            packCode: code,
            stickers: [],
            category: category,
            downloadsCount: 0,
            likesCount: 0,
            isAnimated: isAnimated,
            trayImageSymbol: isAnimated ? "play.circle.fill" : "sparkles"
        )
        myPacks.insert(newPack, at: 0)
        savePacks()
        return newPack
    }

    public func addSticker(to packId: String, sticker: StickerItem) {
        if let index = myPacks.firstIndex(where: { $0.id == packId }) {
            myPacks[index].stickers.append(sticker)
            savePacks()
        }
    }

    public func deleteSticker(from packId: String, stickerId: String) {
        if let index = myPacks.firstIndex(where: { $0.id == packId }) {
            myPacks[index].stickers.removeAll { $0.id == stickerId }
            savePacks()
        }
    }

    public func deletePack(packId: String) {
        myPacks.removeAll { $0.id == packId }
        savePacks()
    }

    // MARK: - Pack Code Import
    public func importPackByCode(_ rawCode: String) -> StickerPack? {
        let clean = rawCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Check explore packs
        if let found = explorePacks.first(where: { $0.packCode == clean }) {
            var copy = found
            copy.title += " (Imported)"
            myPacks.insert(copy, at: 0)
            savePacks()
            return copy
        }

        // Mock generator for unknown codes
        let imported = StickerPack(
            title: "Pack " + clean,
            author: "Community Creator",
            authorAvatarSymbol: "person.fill.checkmark",
            isVerified: true,
            packCode: clean,
            stickers: [
                StickerItem(name: "Imported 1", imageSymbol: "wand.and.stars", symbolColor: "#00D2D3", emojis: ["✨"]),
                StickerItem(name: "Imported 2", imageSymbol: "bolt.fill", symbolColor: "#FF9F43", emojis: ["⚡"]),
                StickerItem(name: "Imported 3", imageSymbol: "heart.fill", symbolColor: "#FF6B6B", emojis: ["💖"])
            ],
            category: .memes,
            downloadsCount: 840,
            likesCount: 210,
            isAnimated: false
        )
        myPacks.insert(imported, at: 0)
        savePacks()
        return imported
    }

    // MARK: - Actions
    public func toggleFavorite(packId: String) {
        if let idx = explorePacks.firstIndex(where: { $0.id == packId }) {
            explorePacks[idx].isFavorite.toggle()
        }
        if let idx = myPacks.firstIndex(where: { $0.id == packId }) {
            myPacks[idx].isFavorite.toggle()
            savePacks()
        }
    }

    public func toggleInstall(packId: String) {
        if let idx = explorePacks.firstIndex(where: { $0.id == packId }) {
            explorePacks[idx].isInstalled.toggle()
            if explorePacks[idx].isInstalled {
                explorePacks[idx].downloadsCount += 1
                if !myPacks.contains(where: { $0.id == packId }) {
                    myPacks.append(explorePacks[idx])
                    savePacks()
                }
            }
        }
    }
}
