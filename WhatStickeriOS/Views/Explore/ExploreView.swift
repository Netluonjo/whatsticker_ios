import SwiftUI

public struct ExploreView: View {
    @ObservedObject var repository = StickerRepository.shared
    @ObservedObject var storeKit = StoreKitManager.shared
    @Binding var showPaywall: Bool

    @State private var searchText: String = ""
    @State private var selectedCategory: StickerCategory = .all
    @State private var selectedPack: StickerPack?

    public init(showPaywall: Binding<Bool>) {
        self._showPaywall = showPaywall
    }

    private var filteredPacks: [StickerPack] {
        repository.explorePacks.filter { pack in
            let matchesCategory = (selectedCategory == .all || pack.category == selectedCategory)
            let matchesSearch = searchText.isEmpty || pack.title.localizedCaseInsensitiveContains(searchText) || pack.author.localizedCaseInsensitiveContains(searchText) || pack.packCode.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    public var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Tìm kiếm bộ sticker, tác giả hoặc mã code...", text: $searchText)
                            .font(.system(size: 15))
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Hero Banner
                    bannerSection

                    // Category Filter Pills
                    categoryFilterSection

                    // Packs Grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(filteredPacks) { pack in
                            packCardView(for: pack)
                                .onTapGesture {
                                    selectedPack = pack
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .padding(.top, 8)
            }
            .navigationTitle("Khám phá Sticker")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showPaywall = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            Text("VIP")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.yellow.opacity(0.15))
                        .cornerRadius(20)
                    }
                }
            }
            .sheet(item: $selectedPack) { pack in
                PackDetailSheet(pack: pack, showPaywall: $showPaywall)
            }
        }
    }

    // MARK: - Banner
    private var bannerSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#00D2D3"), Color(hex: "#54A0FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(16)

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("TÌM STICKER KHÔNG GIỚI HẠN")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white.opacity(0.85))

                    Text("Hàng nghìn meme & sticker đỉnh cao mỗi ngày!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)

                    Button(action: { showPaywall = true }) {
                        Text("Khám phá gói VIP")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                    .padding(.top, 4)
                }

                Spacer()

                Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(16)
        }
        .padding(.horizontal)
    }

    // MARK: - Categories
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(StickerCategory.allCases) { category in
                    Button(action: { selectedCategory = category }) {
                        HStack(spacing: 6) {
                            Image(systemName: category.iconName)
                                .font(.system(size: 12))
                            Text(category.rawValue)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedCategory == category ? Color(hex: "#00D2D3") : Color(UIColor.secondarySystemBackground))
                        .foregroundColor(selectedCategory == category ? .white : .primary)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Pack Card
    private func packCardView(for pack: StickerPack) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Preview 2x2 sticker grid
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .frame(height: 140)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(pack.stickers.prefix(4)) { sticker in
                        Image(systemName: sticker.imageSymbol)
                            .font(.system(size: 26))
                            .foregroundColor(Color(hex: sticker.symbolColor))
                            .frame(width: 44, height: 44)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(8)
                    }
                }
                .padding(8)

                if pack.isAnimated {
                    VStack {
                        HStack {
                            Spacer()
                            Text("GIF")
                                .font(.system(size: 9, weight: .heavy))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                                .padding(8)
                        }
                        Spacer()
                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(pack.title)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Text(pack.author)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    if pack.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.blue)
                    }
                }

                HStack {
                    Label("\(pack.downloadsCount / 1000)k", systemImage: "arrow.down.circle")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)

                    Spacer()

                    Label("\(pack.likesCount / 1000)k", systemImage: "heart.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.pink)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(10)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}
