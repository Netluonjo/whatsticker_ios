import SwiftUI

public struct MemeCreatorSheet: View {
    public let template: MemeTemplate
    @ObservedObject var repository = StickerRepository.shared
    @Environment(\.dismiss) private var dismiss

    @State private var topText: String = ""
    @State private var bottomText: String = ""
    @State private var fontSize: CGFloat = 20
    @State private var textColorHex: String = "#FFFFFF"
    @State private var strokeColorHex: String = "#000000"
    @State private var savedSuccess: Bool = false

    public init(template: MemeTemplate) {
        self.template = template
        _topText = State(initialValue: template.defaultTopText)
        _bottomText = State(initialValue: template.defaultBottomText)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Meme Preview Box
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(hex: template.accentColorHex).opacity(0.15))
                            .frame(height: 280)

                        VStack {
                            // Top Meme Caption
                            Text(topText.uppercased())
                                .font(.system(size: fontSize, weight: .black, design: .rounded))
                                .foregroundColor(Color(hex: textColorHex))
                                .shadow(color: Color(hex: strokeColorHex), radius: 2)
                                .shadow(color: Color(hex: strokeColorHex), radius: 2)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)

                            Spacer()

                            Image(systemName: template.symbolIcon)
                                .font(.system(size: 80))
                                .foregroundColor(Color(hex: template.accentColorHex))

                            Spacer()

                            // Bottom Meme Caption
                            Text(bottomText.uppercased())
                                .font(.system(size: fontSize, weight: .black, design: .rounded))
                                .foregroundColor(Color(hex: textColorHex))
                                .shadow(color: Color(hex: strokeColorHex), radius: 2)
                                .shadow(color: Color(hex: strokeColorHex), radius: 2)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 16)
                        }
                    }
                    .padding(.horizontal)

                    // Text Inputs
                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Dòng chữ trên (Top text)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                            TextField("Nhập chữ trên...", text: $topText)
                                .padding(12)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Dòng chữ dưới (Bottom text)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                            TextField("Nhập chữ dưới...", text: $bottomText)
                                .padding(12)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                        }

                        // Font size slider
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Cỡ chữ: \(Int(fontSize))pt")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            Slider(value: $fontSize, in: 14...36, step: 1)
                                .accentColor(Color(hex: template.accentColorHex))
                        }
                    }
                    .padding(.horizontal)

                    // Save Button
                    Button(action: saveMemeSticker) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Lưu thành Sticker của tôi")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: template.accentColorHex))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .padding(.vertical)
            }
            .navigationTitle("Tạo Meme 1-Chạm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Xong") { dismiss() }
                }
            }
            .alert(isPresented: $savedSuccess) {
                Alert(
                    title: Text("Thành công! 🎉"),
                    message: Text("Sticker Meme đã được lưu vào bộ sưu tập cá nhân của bạn."),
                    dismissButton: .default(Text("Tuyệt vời"), action: { dismiss() })
                )
            }
        }
    }

    private func saveMemeSticker() {
        let newSticker = StickerItem(
            name: template.name,
            imageSymbol: template.symbolIcon,
            symbolColor: template.accentColorHex,
            emojis: ["😂", "🔥"],
            topCaption: topText,
            bottomCaption: bottomText
        )

        if let firstPack = repository.myPacks.first {
            repository.addSticker(to: firstPack.id, sticker: newSticker)
        } else {
            let created = repository.createPack(title: "Meme Bộ Sưu Tập")
            repository.addSticker(to: created.id, sticker: newSticker)
        }

        savedSuccess = true
    }
}
