import SwiftUI

public struct CreateOptionsSheet: View {
    public let onSelectStatic: () -> Void
    public let onSelectAnimated: () -> Void
    public let onSelectMeme: () -> Void

    public init(
        onSelectStatic: @escaping () -> Void,
        onSelectAnimated: @escaping () -> Void,
        onSelectMeme: @escaping () -> Void
    ) {
        self.onSelectStatic = onSelectStatic
        self.onSelectAnimated = onSelectAnimated
        self.onSelectMeme = onSelectMeme
    }

    public var body: some View {
        VStack(spacing: 20) {
            // Drag indicator
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 10)

            Text("Tạo Sticker Mới")
                .font(.system(size: 18, weight: .bold))

            VStack(spacing: 12) {
                // Option 1: Static / Magic Cut
                Button(action: onSelectStatic) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#00D2D3"), Color(hex: "#54A0FF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 50, height: 50)
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Sticker Tĩnh & Tách Nền AI")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Tự động xóa phông, tạo viền trắng, thêm chữ & emoji")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(14)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(14)
                }

                // Option 2: Animated / Video
                Button(action: onSelectAnimated) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#A55EEA"), Color(hex: "#45AAF2")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 50, height: 50)
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Sticker Động (Video / GIF)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Trích xuất khung hình từ video clip ngắn hoặc file GIF")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(14)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(14)
                }

                // Option 3: Meme Template
                Button(action: onSelectMeme) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#FF6B6B"), Color(hex: "#FF9F43")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 50, height: 50)
                            Image(systemName: "quote.bubble.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Mẫu Meme Kinh Điển")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                            Text("Chọn từ kho 20+ meme hot và sửa chữ nhanh")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(14)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(14)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}

