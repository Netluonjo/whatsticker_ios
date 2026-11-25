import Foundation
import UIKit

public final class WhatsAppExporter {
    public static let shared = WhatsAppExporter()

    private let pasteboardName = "net.whatsapp.WhatsApp.app.stickerPack"
    private let whatsappURLScheme = "whatsapp://stickerPack"

    private init() {}

    public var isWhatsAppInstalled: Bool {
        guard let url = URL(string: "whatsapp://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// Prepares WhatsApp Sticker Pack dictionary according to official WhatsApp iOS Sticker specification
    public func exportToWhatsApp(pack: StickerPack, completion: @escaping (Bool, String) -> Void) {
        guard isWhatsAppInstalled else {
            completion(false, "WhatsApp chưa được cài đặt trên thiết bị này.")
            return
        }

        var stickerDicts: [[String: Any]] = []

        for sticker in pack.stickers {
            var item: [String: Any] = [:]
            item["emojis"] = sticker.emojis

            // Render 512x512 image data
            let renderedImage = StickerProcessor.shared.renderCompositeSticker(
                baseImage: sticker.imageData != nil ? UIImage(data: sticker.imageData!) : nil,
                symbolIcon: sticker.imageSymbol,
                symbolColor: UIColor(hex: sticker.symbolColor) ?? .systemBlue,
                outlineWidth: 6,
                outlineColor: .white,
                textOverlays: [],
                emojiOverlays: []
            )

            if let pngData = renderedImage.pngData() {
                item["image_data"] = pngData.base64EncodedString()
                stickerDicts.append(item)
            }
        }

        guard !stickerDicts.isEmpty else {
            completion(false, "Bộ sticker không có hình nào hợp lệ để xuất.")
            return
        }

        // Render tray icon
        let trayImage = UIImage(systemName: pack.trayImageSymbol)?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal) ?? UIImage()
        let trayData = trayImage.pngData() ?? Data()

        let payload: [String: Any] = [
            "identifier": pack.id,
            "name": pack.title,
            "publisher": pack.author,
            "tray_image": trayData.base64EncodedString(),
            "stickers": stickerDicts
        ]

        if let jsonString = try? JSONSerialization.data(withJSONObject: payload, options: []) {
            let pasteboard = UIPasteboard.general
            pasteboard.setData(jsonString, forPasteboardType: pasteboardName)

            if let url = URL(string: whatsappURLScheme) {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        completion(true, "Đang mở WhatsApp để thêm bộ sticker...")
                    } else {
                        completion(false, "Không thể chuyển hướng sang WhatsApp.")
                    }
                }
            }
        } else {
            completion(false, "Lỗi tạo cấu trúc dữ liệu WhatsApp.")
        }
    }
}

