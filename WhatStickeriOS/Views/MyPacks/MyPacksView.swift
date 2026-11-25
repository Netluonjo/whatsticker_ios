import SwiftUI

public struct MyPacksView: View {
    @ObservedObject var repository = StickerRepository.shared
    @Binding var showCreateSheet: Bool

    @State private var showImportDialog: Bool = false
    @State private var showNewPackDialog: Bool = false
    @State private var newPackTitle: String = ""
    @State private var selectedPack: StickerPack?
    @State private var showPaywall: Bool = false

    public init(showCreateSheet: Binding<Bool>) {
        self._showCreateSheet = showCreateSheet
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Quick Action Bar
                    HStack(spacing: 12) {
                        Button(action: { showNewPackDialog = true }) {
                            HStack {
                                Image(systemName: "folder.badge.plus")
                                Text("Tạo Bộ Mới")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(hex: "#00D2D3"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }

                        Button(action: { showImportDialog = true }) {
                            HStack {
                                Image(systemName: "qrcode.viewfinder")
                                Text("Nhập Mã Code")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.secondarySystemBackground))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)

                    // Packs List
                    if repository.myPacks.isEmpty {
                        VStack(spacing: 14) {
                            Image(systemName: "square.stack.3d.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            Text("Chưa có bộ sticker nào")
                                .font(.system(size: 16, weight: .bold))
                            Text("Bắt đầu bằng cách tạo sticker mới hoặc nhập mã từ bạn bè!")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(40)
                    } else {
                        VStack(spacing: 14) {
                            ForEach(repository.myPacks) { pack in
                                packRowItem(pack: pack)
                                    .onTapGesture {
                                        selectedPack = pack
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 12)
            }
            .navigationTitle("Bộ Sưu Tập Của Tôi")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showImportDialog) {
                ImportCodeDialog()
                    .presentationDetents([.fraction(0.55)])
            }
            .sheet(item: $selectedPack) { pack in
                PackDetailSheet(pack: pack, showPaywall: $showPaywall)
            }
            .alert("Tạo Bộ Sticker Mới", isPresented: $showNewPackDialog) {
                TextField("Tên bộ sticker...", text: $newPackTitle)
                Button("Hủy", role: .cancel) { newPackTitle = "" }
                Button("Tạo") {
                    if !newPackTitle.isEmpty {
                        _ = repository.createPack(title: newPackTitle)
                        newPackTitle = ""
                    }
                }
            }
        }
    }

    private func packRowItem(pack: StickerPack) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#00D2D3").opacity(0.15))
                    .frame(width: 60, height: 60)
                Image(systemName: pack.trayImageSymbol)
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "#00D2D3"))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(pack.title)
                    .font(.system(size: 16, weight: .bold))

                HStack(spacing: 10) {
                    Text(pack.packCode)
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(.secondary)

                    Text("•")
                        .foregroundColor(.secondary)

                    Text("\(pack.stickers.count) sticker")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: {
                WhatsAppExporter.shared.exportToWhatsApp(pack: pack) { _, _ in }
            }) {
                Image(systemName: "message.fill")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color(hex: "#25D366"))
                    .clipShape(Circle())
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

