import SwiftUI

@main
struct WhatStickeriOSApp: App {
    @StateObject private var repository = StickerRepository.shared
    @StateObject private var storeKit = StoreKitManager.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(repository)
                .environmentObject(storeKit)
        }
    }
}
