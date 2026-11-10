import SwiftUI

public struct PackDetailSheet: View {
    public let pack: StickerPack
    @Binding var showPaywall: Bool
    @ObservedObject var repository = StickerRepository.shared
    @ObservedObject var storeKit = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss

    @State private var alertMessage: String?
    @State private var showAlert: Bool = false
    @State private var copiedCode: Bool = false

    public init(pack: StickerPack, showPaywall: Binding<Bool>) {
        self.pack = pack
        self._showPaywall = showPaywall
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#00D2D3").opacity(0.15))
                                    .frame(width: 68, height: 68)
                                Image(systemName: pack.trayImageSymbol)
                                    .font(.system(size: 32))
                                    .foregroundColor(Color(hex: "#00D2D3"))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(pack.title)
                                    .font(.system(size: 20, weight: .bold))

                                HStack(spacing: 6) {
                                    Text(pack.author)
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)

                                    if pack.isVerified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.blue)
                                            .font(.system(size: 13))
                                    }
                                }

                                HStack(spacing: 12) {
                                    Label("\(pack.stickers.count) sticker", systemImage: "square.grid.2x2")
                                    Label("\(pack.downloadsCount) tải", systemImage: "arrow.down.circle")
                                }
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            }

                            Spacer()
                        }

                        // Pack Code Pill
                        HStack {
                            Text("Mã Pack:")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            Text(pack.packCode)
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(hex: "#00D2D3"))

                            Spacer()

                            Button(action: {
                                UIPasteboard.general.string = pack.packCode
                                copiedCode = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    copiedCode = false
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: copiedCode ? "checkmark" : "doc.on.doc")
                                    Text(copiedCode ? "Đã chép" : "Sao chép")
                                }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)

                    // Export Action Buttons
                    VStack(spacing: 10) {
                        Button(action: handleWhatsAppExport) {
                            HStack {
                                Image(systemName: "message.fill")
                                Text("Thêm vào WhatsApp")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#25D366"))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }

                        HStack(spacing: 12) {
                            Button(action: handleTelegramExport) {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                    Text("Xuất Telegram")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(hex: "#0088CC"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }

                            Button(action: {
                                repository.toggleInstall(packId: pack.id)
                            }) {
                                HStack {
                                    Image(systemName: pack.isInstalled ? "checkmark.circle.fill" : "plus.circle.fill")
                                    Text(pack.isInstalled ? "Đã lưu" : "Lưu vào máy")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Sticker Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tất cả sticker trong bộ (\(pack.stickers.count))")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.horizontal)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            ForEach(pack.stickers) { sticker in
                                VStack(spacing: 8) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(UIColor.secondarySystemBackground))
                                            .frame(height: 100)

                                        Image(systemName: sticker.imageSymbol)
                                            .font(.system(size: 38))
                                            .foregroundColor(Color(hex: sticker.symbolColor))
                                    }

                                    HStack(spacing: 4) {
                                        ForEach(sticker.emojis, id: \.self) { emoji in
                                            Text(emoji)
                                                .font(.system(size: 14))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Chi tiết bộ Sticker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Thông báo"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func handleWhatsAppExport() {
        if pack.isVipOnly && !storeKit.isVipSubscribed {
            showPaywall = true
            return
        }

        WhatsAppExporter.shared.exportToWhatsApp(pack: pack) { success, msg in
            alertMessage = msg
            showAlert = true
        }
    }

    private func handleTelegramExport() {
        TelegramExporter.shared.openTelegramStickersBot()
    }
}
