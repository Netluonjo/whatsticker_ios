import SwiftUI

public struct MainTabView: View {
    @StateObject private var repository = StickerRepository.shared
    @StateObject private var storeKit = StoreKitManager.shared

    @State private var selectedTab: Int = 0
    @State private var showCreateOptions: Bool = false
    @State private var showPaywall: Bool = false
    @State private var showStaticEditor: Bool = false
    @State private var showAnimatedEditor: Bool = false
    @State private var showMemeCreator: Bool = false
    @State private var selectedTemplateForMeme: MemeTemplate?

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ExploreView(showPaywall: $showPaywall)
                    .tabItem {
                        Label("Khám phá", systemImage: "sparkles")
                    }
                    .tag(0)

                TemplatesView(selectedTemplate: $selectedTemplateForMeme, showMemeCreator: $showMemeCreator)
                    .tabItem {
                        Label("Mẫu Meme", systemImage: "quote.bubble.fill")
                    }
                    .tag(1)

                Color.clear
                    .tabItem {
                        Label("Tạo mới", systemImage: "plus.circle.fill")
                    }
                    .tag(2)

                MyPacksView(showCreateSheet: $showCreateOptions)
                    .tabItem {
                        Label("Bộ sưu tập", systemImage: "square.stack.3d.up.fill")
                    }
                    .tag(3)

                ProfileView(showPaywall: $showPaywall)
                    .tabItem {
                        Label("Hồ sơ", systemImage: "person.crop.circle.fill")
                    }
                    .tag(4)
            }
            .accentColor(Color(hex: "#00D2D3"))
            .onChange(of: selectedTab) { newTab in
                if newTab == 2 {
                    // Middle "+" tab intercepted to show modal
                    showCreateOptions = true
                    selectedTab = 0
                }
            }
        }
        .sheet(isPresented: $showCreateOptions) {
            CreateOptionsSheet(
                onSelectStatic: {
                    showCreateOptions = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showStaticEditor = true
                    }
                },
                onSelectAnimated: {
                    showCreateOptions = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showAnimatedEditor = true
                    }
                },
                onSelectMeme: {
                    showCreateOptions = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedTab = 1
                    }
                }
            )
            .presentationDetents([.fraction(0.45)])
        }
        .fullScreenCover(isPresented: $showStaticEditor) {
            StickerEditorView()
        }
        .fullScreenCover(isPresented: $showAnimatedEditor) {
            AnimatedEditorView()
        }
        .sheet(isPresented: $showMemeCreator) {
            if let template = selectedTemplateForMeme {
                MemeCreatorSheet(template: template)
            }
        }
        .sheet(isPresented: $showPaywall) {
            VipPaywallView()
        }
    }
}
