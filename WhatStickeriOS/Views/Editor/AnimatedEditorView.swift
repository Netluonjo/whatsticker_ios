import SwiftUI

public struct AnimatedEditorView: View {
    @ObservedObject var repository = StickerRepository.shared
    @Environment(\.dismiss) private var dismiss

    @State private var currentFrameIndex: Int = 0
    @State private var fps: Double = 12.0
    @State private var isPlaying: Bool = true
    @State private var showSuccess: Bool = false

    private let sampleIcons = [
        "heart.circle.fill",
        "bolt.heart.fill",
        "sparkles",
        "flame.fill",
        "star.fill",
        "moon.stars.fill"
    ]

    private let timer = Timer.publish(every: 1.0 / 12.0, on: .main, in: .common).autoconnect()

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // Animated Loop Preview Canvas
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .frame(width: 260, height: 260)
                        .shadow(color: Color.black.opacity(0.08), radius: 10)

                    Image(systemName: sampleIcons[currentFrameIndex % sampleIcons.count])
                        .font(.system(size: 110))
                        .foregroundColor(Color(hex: "#A55EEA"))
                        .scaleEffect(1.0 + CGFloat(currentFrameIndex % 3) * 0.1)
                        .animation(.spring(response: 0.2), value: currentFrameIndex)

                    VStack {
                        Spacer()
                        HStack {
                            Text("Frame \(currentFrameIndex + 1)/\(sampleIcons.count)")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 12)
                    }
                }

                // Controls
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        Button(action: { isPlaying.toggle() }) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 24))
                                .frame(width: 56, height: 56)
                                .background(Color(hex: "#A55EEA"))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }

                    // FPS Selector
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Tốc độ khung hình (FPS): \(Int(fps)) FPS")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        Slider(value: $fps, in: 6...24, step: 2)
                            .accentColor(Color(hex: "#A55EEA"))
                    }
                    .padding(.horizontal, 32)
                }

                Spacer()

                // Save Animated Sticker Button
                Button(action: saveAnimatedSticker) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Lưu Sticker Động (Animated)")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#A55EEA"))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("Tạo Sticker Động")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Đóng") { dismiss() }
                }
            }
            .onReceive(timer) { _ in
                if isPlaying {
                    currentFrameIndex = (currentFrameIndex + 1) % sampleIcons.count
                }
            }
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("Đã lưu Sticker động!"),
                    message: Text("Sticker động đã được tạo và lưu thành công."),
                    dismissButton: .default(Text("OK"), action: { dismiss() })
                )
            }
        }
    }

    private func saveAnimatedSticker() {
        let newSticker = StickerItem(
            name: "Animated Magic",
            imageSymbol: sampleIcons[0],
            symbolColor: "#A55EEA",
            emojis: ["✨", "💜"],
            isAnimated: true,
            frameCount: sampleIcons.count,
            fps: fps
        )

        if let firstPack = repository.myPacks.first {
            repository.addSticker(to: firstPack.id, sticker: newSticker)
        } else {
            let created = repository.createPack(title: "Animated Stickers", isAnimated: true)
            repository.addSticker(to: created.id, sticker: newSticker)
        }

        showSuccess = true
    }
}
