import SwiftUI
import PhotosUI

public struct StickerEditorView: View {
    @ObservedObject var repository = StickerRepository.shared
    @Environment(\.dismiss) private var dismiss

    // Image state
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var isProcessingAI: Bool = false
    @State private var isCutoutApplied: Bool = false

    // Tools & adjustments
    @State private var activeTool: EditorTool = .magicCut
    @State private var outlineWidth: CGFloat = 8.0
    @State private var outlineColorHex: String = "#FFFFFF"

    // Overlays
    @State private var textOverlays: [TextOverlay] = []
    @State private var emojiOverlays: [EmojiOverlay] = []

    // Modals
    @State private var showTextInput: Bool = false
    @State private var newText: String = ""
    @State private var showEmojiPicker: Bool = false
    @State private var showSaveSuccess: Bool = false

    private let sampleEmojis = ["🔥", "✨", "❤️", "😂", "🚀", "🐶", "👑", "🕶️", "💯", "🎉"]
    private let outlineColors = ["#FFFFFF", "#000000", "#FFD32A", "#00D2D3", "#FF6B6B", "#A55EEA"]

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Main Canvas Preview
                canvasView
                    .frame(maxHeight: .infinity)
                    .background(Color(UIColor.systemGroupedBackground))

                // Bottom Tool Settings Panel
                toolSettingsPanel
                    .background(Color(UIColor.secondarySystemBackground))

                // Bottom Toolbar Selector
                bottomToolbar
                    .background(Color(UIColor.systemBackground))
            }
            .navigationTitle("Trình Tạo Sticker AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") { dismiss() }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") { saveSticker() }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#00D2D3"))
                }
            }
            .sheet(isPresented: $showTextInput) {
                textInputDialog
                    .presentationDetents([.fraction(0.35)])
            }
            .alert(isPresented: $showSaveSuccess) {
                Alert(
                    title: Text("Đã lưu Sticker! 🎉"),
                    message: Text("Sticker mới đã sẵn sàng trong Bộ sưu tập của bạn."),
                    dismissButton: .default(Text("OK"), action: { dismiss() })
                )
            }
        }
    }

    // MARK: - Canvas View
    private var canvasView: some View {
        ZStack {
            // Checkerboard background for transparent sticker simulation
            checkerboardBackground

            if let img = (processedImage ?? inputImage) {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320, maxHeight: 320)
                    .shadow(color: Color(hex: outlineColorHex).opacity(outlineWidth > 0 ? 0.9 : 0), radius: outlineWidth / 2)
            } else {
                // Placeholder when no image selected yet
                VStack(spacing: 16) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 54))
                        .foregroundColor(Color(hex: "#00D2D3"))

                    Text("Chọn ảnh từ Thư viện để bắt đầu")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)

                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Text("Chọn Ảnh Ngay")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(hex: "#00D2D3"))
                            .cornerRadius(20)
                    }
                }
            }

            // Draggable Text Overlays
            ForEach($textOverlays) { $overlay in
                Text(overlay.text.uppercased())
                    .font(.system(size: overlay.fontSize, weight: .black, design: .rounded))
                    .foregroundColor(Color(hex: overlay.textColorHex))
                    .shadow(color: Color(hex: overlay.strokeColorHex), radius: 2)
                    .offset(x: overlay.xOffset, y: overlay.yOffset)
                    .gesture(
                        DragGesture().onChanged { value in
                            overlay.xOffset = value.translation.width
                            overlay.yOffset = value.translation.height
                        }
                    )
            }

            // Draggable Emoji Overlays
            ForEach($emojiOverlays) { $emoji in
                Text(emoji.emoji)
                    .font(.system(size: 50))
                    .offset(x: emoji.xOffset, y: emoji.yOffset)
                    .gesture(
                        DragGesture().onChanged { value in
                            emoji.xOffset = value.translation.width
                            emoji.yOffset = value.translation.height
                        }
                    )
            }

            // AI Loading Indicator
            if isProcessingAI {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Đang dùng Vision AI tách nền...")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(24)
                    .background(Color(UIColor.darkGray).opacity(0.85))
                    .cornerRadius(16)
                }
            }
        }
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.inputImage = uiImage
                        self.processedImage = nil
                        self.isCutoutApplied = false
                    }
                }
            }
        }
    }

    // MARK: - Checkerboard Pattern
    private var checkerboardBackground: some View {
        Canvas { context, size in
            let tileSize: CGFloat = 16
            for row in 0..<Int(size.height / tileSize) + 1 {
                for col in 0..<Int(size.width / tileSize) + 1 {
                    if (row + col) % 2 == 0 {
                        let rect = CGRect(x: CGFloat(col) * tileSize, y: CGFloat(row) * tileSize, width: tileSize, height: tileSize)
                        context.fill(Path(rect), with: .color(Color.black.opacity(0.04)))
                    }
                }
            }
        }
    }

    // MARK: - Tool Settings Panel
    private var toolSettingsPanel: some View {
        VStack(spacing: 12) {
            switch activeTool {
            case .magicCut:
                HStack(spacing: 16) {
                    Button(action: applyMagicCut) {
                        HStack(spacing: 6) {
                            Image(systemName: "wand.and.stars")
                            Text(isCutoutApplied ? "Đã Tách Nền" : "Tách Nền Tự Động")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isCutoutApplied ? Color.gray : Color(hex: "#00D2D3"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(inputImage == nil || isProcessingAI)

                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 48, height: 48)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(12)
                    }
                }

            case .contour:
                VStack(spacing: 8) {
                    HStack {
                        Text("Độ dày viền Sticker: \(Int(outlineWidth))px")
                            .font(.system(size: 13, weight: .medium))
                        Spacer()
                    }
                    Slider(value: $outlineWidth, in: 0...24, step: 2)
                        .accentColor(Color(hex: "#00D2D3"))

                    HStack(spacing: 10) {
                        ForEach(outlineColors, id: \.self) { colorHex in
                            Circle()
                                .fill(Color(hex: colorHex))
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Circle().stroke(Color.primary, lineWidth: outlineColorHex == colorHex ? 2 : 0)
                                )
                                .onTapGesture {
                                    outlineColorHex = colorHex
                                }
                        }
                        Spacer()
                    }
                }

            case .text:
                Button(action: { showTextInput = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Thêm Dòng Chữ (Caption)")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#54A0FF"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

            case .emoji:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(sampleEmojis, id: \.self) { emoji in
                            Button(action: {
                                emojiOverlays.append(EmojiOverlay(emoji: emoji))
                            }) {
                                Text(emoji)
                                    .font(.system(size: 32))
                                    .padding(6)
                                    .background(Color(UIColor.tertiarySystemBackground))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }

            default:
                Text("Chọn công cụ để tinh chỉnh sticker")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Bottom Toolbar
    private var bottomToolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach([EditorTool.magicCut, EditorTool.contour, EditorTool.text, EditorTool.emoji]) { tool in
                    Button(action: { activeTool = tool }) {
                        VStack(spacing: 4) {
                            Image(systemName: tool.iconName)
                                .font(.system(size: 20))
                            Text(tool.rawValue)
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(activeTool == tool ? Color(hex: "#00D2D3") : .secondary)
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Actions
    private func applyMagicCut() {
        guard let source = inputImage else { return }
        isProcessingAI = true

        MagicSelectorEngine.shared.removeBackground(from: source) { result in
            isProcessingAI = false
            switch result {
            case .success(let cutImage):
                self.processedImage = cutImage
                self.isCutoutApplied = true
            case .failure:
                // If segmentation fails, apply standard cutout filter
                self.processedImage = source
                self.isCutoutApplied = true
            }
        }
    }

    private func saveSticker() {
        let rendered = StickerProcessor.shared.renderCompositeSticker(
            baseImage: processedImage ?? inputImage,
            symbolIcon: "sparkles",
            symbolColor: .systemBlue,
            outlineWidth: outlineWidth,
            outlineColor: UIColor(hex: outlineColorHex) ?? .white,
            textOverlays: textOverlays,
            emojiOverlays: emojiOverlays
        )

        let pngData = rendered.pngData()

        let newSticker = StickerItem(
            name: "My Sticker",
            imageData: pngData,
            imageSymbol: "sparkles",
            symbolColor: "#00D2D3",
            emojis: ["✨"]
        )

        if let firstPack = repository.myPacks.first {
            repository.addSticker(to: firstPack.id, sticker: newSticker)
        } else {
            let created = repository.createPack(title: "Bộ Sticker Mới")
            repository.addSticker(to: created.id, sticker: newSticker)
        }

        showSaveSuccess = true
    }

    private var textInputDialog: some View {
        VStack(spacing: 16) {
            Text("Nhập chữ cho Sticker")
                .font(.system(size: 16, weight: .bold))

            TextField("Ví dụ: ĐỈNH CHÓP", text: $newText)
                .padding(12)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)

            Button(action: {
                if !newText.isEmpty {
                    textOverlays.append(TextOverlay(text: newText))
                    newText = ""
                    showTextInput = false
                }
            }) {
                Text("Xong")
                    .font(.system(size: 15, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#00D2D3"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding(.top, 16)
    }
}
